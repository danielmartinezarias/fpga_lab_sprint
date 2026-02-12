#!/usr/bin/env python3
"""
DPS3005 Power Supply Control Script
Controls DPS3005/DPS5005 programmable power supply via UART/Modbus RTU
"""

import sys
sys.path.append("/home/petalinux/fpga_lab_sprint/python/zedboard_pkgs")
import serial
import struct
import time
import argparse


class DPS3005:
    """Class to control DPS3005 power supply via Modbus RTU"""
    
    def __init__(self, port='/dev/ttyUSB0', address=0x01, baudrate=9600, timeout=1):
        """
        Initialize connection to DPS3005
        
        Args:
            port: Serial port device path
            address: Modbus device address (default 0x01)
            baudrate: Serial baudrate (default 9600)
            timeout: Read timeout in seconds
        """
        self.port = port
        self.address = address
        self.ser = serial.Serial(port, baudrate, timeout=timeout)
        time.sleep(0.1)  # Give device time to initialize
        
    def __enter__(self):
        return self
        
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()
        
    def close(self):
        """Close serial connection"""
        if self.ser.is_open:
            self.ser.close()
    
    def _crc16_modbus(self, data):
        """Calculate Modbus CRC16"""
        crc = 0xFFFF
        for byte in data:
            crc ^= byte
            for _ in range(8):
                if crc & 0x0001:
                    crc = (crc >> 1) ^ 0xA001
                else:
                    crc >>= 1
        return struct.pack('<H', crc)  # Little-endian
    
    def _send_command(self, function_code, register, num_registers=1, value=None):
        """
        Send Modbus RTU command
        
        Args:
            function_code: Modbus function code (0x03 read, 0x06 write single, 0x10 write multiple)
            register: Register address
            num_registers: Number of registers to read/write
            value: Value to write (for write commands)
        
        Returns:
            Response bytes or None on error
        """
        # Build command
        if function_code == 0x03:  # Read holding registers
            cmd = struct.pack('>BBHH', self.address, function_code, register, num_registers)
        elif function_code == 0x06:  # Write single register
            cmd = struct.pack('>BBHH', self.address, function_code, register, value)
        elif function_code == 0x10:  # Write multiple registers
            byte_count = num_registers * 2
            cmd = struct.pack('>BBHHB', self.address, function_code, register, num_registers, byte_count)
            for val in value:
                cmd += struct.pack('>H', val)
        else:
            raise ValueError(f"Unsupported function code: {function_code}")
        
        # Add CRC
        cmd += self._crc16_modbus(cmd)
        
        # Send command
        self.ser.reset_input_buffer()
        self.ser.write(cmd)
        
        # Read response
        time.sleep(0.05)  # Small delay for device to respond
        
        # Calculate expected response length
        if function_code == 0x03:
            expected_len = 5 + (num_registers * 2)
        elif function_code in [0x06, 0x10]:
            expected_len = 8
        else:
            expected_len = 8
            
        response = self.ser.read(expected_len)
        
        if len(response) < 5:
            print(f"Error: Short response ({len(response)} bytes)")
            return None
            
        # Verify CRC
        received_crc = response[-2:]
        calculated_crc = self._crc16_modbus(response[:-2])
        
        if received_crc != calculated_crc:
            print(f"Error: CRC mismatch. Received: {received_crc.hex()}, Calculated: {calculated_crc.hex()}")
            return None
            
        return response
    
    def read_voltage_current(self):
        """
        Read output voltage and current
        
        Returns:
            tuple: (voltage, current) in V and A, or (None, None) on error
        """
        response = self._send_command(0x03, 0x0002, 2)
        
        if response and len(response) >= 9:
            voltage = struct.unpack('>H', response[3:5])[0] / 100.0
            current = struct.unpack('>H', response[5:7])[0] / 1000.0
            return voltage, current
        return None, None
    
    def read_voltage_setting(self):
        """
        Read voltage setting
        
        Returns:
            float: Voltage setting in V, or None on error
        """
        response = self._send_command(0x03, 0x0000, 1)
        
        if response and len(response) >= 7:
            voltage = struct.unpack('>H', response[3:5])[0] / 100.0
            return voltage
        return None
    
    def read_current_setting(self):
        """
        Read current limit setting
        
        Returns:
            float: Current limit in A, or None on error
        """
        response = self._send_command(0x03, 0x0001, 1)
        
        if response and len(response) >= 7:
            current = struct.unpack('>H', response[3:5])[0] / 1000.0
            return current
        return None
    
    def set_voltage(self, voltage):
        """
        Set output voltage
        
        Args:
            voltage: Voltage in V (0-30V for DPS3005, 0-50V for DPS5005)
        
        Returns:
            bool: True if successful, False otherwise
        """
        voltage_raw = int(voltage * 100)
        response = self._send_command(0x06, 0x0000, value=voltage_raw)
        return response is not None
    
    def set_current(self, current):
        """
        Set current limit
        
        Args:
            current: Current in A (0-5A for DPS3005, 0-5A for DPS5005)
        
        Returns:
            bool: True if successful, False otherwise
        """
        current_raw = int(current * 100)
        response = self._send_command(0x06, 0x0001, value=current_raw)
        return response is not None
    
    def set_output(self, enable):
        """
        Enable/disable output
        
        Args:
            enable: True to enable output, False to disable
        
        Returns:
            bool: True if successful, False otherwise
        """
        value = 1 if enable else 0
        response = self._send_command(0x06, 0x0009, value=value)
        return response is not None
    
    def read_output_state(self):
        """
        Read output on/off state
        
        Returns:
            bool: True if output is on, False if off, None on error
        """
        response = self._send_command(0x03, 0x0009, 1)
        
        if response and len(response) >= 7:
            state = struct.unpack('>H', response[3:5])[0]
            return state == 1
        return None
    
    def read_protection_status(self):
        """
        Read protection status
        
        Returns:
            dict: Protection status flags, or None on error
        """
        response = self._send_command(0x03, 0x000A, 1)
        
        if response and len(response) >= 7:
            status = struct.unpack('>H', response[3:5])[0]
            return {
                'ovp': bool(status & 0x01),  # Over voltage protection
                'ocp': bool(status & 0x02),  # Over current protection
                'opp': bool(status & 0x04),  # Over power protection
            }
        return None
    
    def read_cv_cc_mode(self):
        """
        Read constant voltage/constant current mode
        
        Returns:
            str: 'CV' for constant voltage, 'CC' for constant current, None on error
        """
        response = self._send_command(0x03, 0x0008, 1)
        
        if response and len(response) >= 7:
            mode = struct.unpack('>H', response[3:5])[0]
            return 'CV' if mode == 0 else 'CC'
        return None
    
    def read_model(self):
        """
        Read device model
        
        Returns:
            int: Model number, or None on error
        """
        response = self._send_command(0x03, 0x000B, 1)
        
        if response and len(response) >= 7:
            model = struct.unpack('>H', response[3:5])[0]
            return model
        return None
    
    def get_status(self):
        """
        Get complete status of the power supply
        
        Returns:
            dict: Complete status information
        """
        v_out, i_out = self.read_voltage_current()
        v_set = self.read_voltage_setting()
        i_set = self.read_current_setting()
        output_on = self.read_output_state()
        mode = self.read_cv_cc_mode()
        protection = self.read_protection_status()
        
        return {
            'voltage_output': v_out,
            'current_output': i_out,
            'voltage_setting': v_set,
            'current_setting': i_set,
            'output_enabled': output_on,
            'mode': mode,
            'protection': protection
        }


def main():
    parser = argparse.ArgumentParser(description='Control DPS3005 Power Supply \r\n Example: python3 dps3005.py -p /dev/ttyUSB0 -a 1 monitor')
    parser.add_argument('-p', '--port', default='/dev/ttyUSB0', help='Serial port (default: /dev/ttyUSB0)')
    parser.add_argument('-a', '--address', type=int, default=1, help='Modbus address (default: 1)')
    
    subparsers = parser.add_subparsers(dest='command', help='Command to execute')
    
    # Status command
    subparsers.add_parser('status', help='Read all status information')
    
    # Read commands
    subparsers.add_parser('read', help='Read output voltage and current')
    subparsers.add_parser('settings', help='Read voltage and current settings')
    
    # Set voltage
    set_v = subparsers.add_parser('set-voltage', help='Set output voltage')
    set_v.add_argument('voltage', type=float, help='Voltage in V')
    
    # Set current
    set_i = subparsers.add_parser('set-current', help='Set current limit')
    set_i.add_argument('current', type=float, help='Current in A')
    
    # Output control
    subparsers.add_parser('on', help='Turn output ON')
    subparsers.add_parser('off', help='Turn output OFF')
    
    # Monitor mode
    monitor = subparsers.add_parser('monitor', help='Continuously monitor output')
    monitor.add_argument('-i', '--interval', type=float, default=1.0, help='Update interval in seconds')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        return
    
    try:
        with DPS3005(port=args.port, address=args.address) as psu:
            
            if args.command == 'status':
                status = psu.get_status()
                print("\n=== DPS3005 Status ===")
                print(f"Output Voltage:    {status['voltage_output']:.2f} V")
                print(f"Output Current:    {status['current_output']:.3f} A")
                print(f"Power:             {status['voltage_output'] * status['current_output']:.2f} W")
                print(f"Voltage Setting:   {status['voltage_setting']:.2f} V")
                print(f"Current Setting:   {status['current_setting']:.3f} A")
                print(f"Output:            {'ON' if status['output_enabled'] else 'OFF'}")
                print(f"Mode:              {status['mode']}")
                if status['protection']:
                    print(f"Protection:        OVP={status['protection']['ovp']}, OCP={status['protection']['ocp']}, OPP={status['protection']['opp']}")
                print()
            
            elif args.command == 'read':
                voltage, current = psu.read_voltage_current()
                if voltage is not None:
                    print(f"Voltage: {voltage:.2f} V")
                    print(f"Current: {current:.3f} A")
                    print(f"Power:   {voltage * current:.2f} W")
            
            elif args.command == 'settings':
                v_set = psu.read_voltage_setting()
                i_set = psu.read_current_setting()
                if v_set is not None:
                    print(f"Voltage Setting: {v_set:.2f} V")
                    print(f"Current Setting: {i_set:.3f} A")
            
            elif args.command == 'set-voltage':
                if psu.set_voltage(args.voltage):
                    print(f"Voltage set to {args.voltage:.2f} V")
                else:
                    print("Failed to set voltage")
            
            elif args.command == 'set-current':
                if psu.set_current(args.current):
                    print(f"Current limit set to {args.current:.3f} A")
                else:
                    print("Failed to set current")
            
            elif args.command == 'on':
                if psu.set_output(True):
                    print("Output enabled")
                else:
                    print("Failed to enable output")
            
            elif args.command == 'off':
                if psu.set_output(False):
                    print("Output disabled")
                else:
                    print("Failed to disable output")
            
            elif args.command == 'monitor':
                print("Monitoring output (Ctrl+C to stop)...")
                print("Time      Voltage  Current  Power    Mode")
                print("-" * 50)
                try:
                    while True:
                        voltage, current = psu.read_voltage_current()
                        mode = psu.read_cv_cc_mode()
                        if voltage is not None:
                            power = voltage * current
                            timestamp = time.strftime("%H:%M:%S")
                            print(f"{timestamp}  {voltage:6.2f}V  {current:6.3f}A  {power:6.2f}W  {mode}")
                        time.sleep(args.interval)
                except KeyboardInterrupt:
                    print("\nMonitoring stopped")
    
    except serial.SerialException as e:
        print(f"Serial port error: {e}")
        print(f"Make sure {args.port} exists and you have permission to access it")
        print(f"Try: sudo chmod o+rw {args.port}")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
