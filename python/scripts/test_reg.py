# read test_reg
import sys
sys.path.append('.')
import time
from drivers import *

if __name__ == "__main__":
    
    z = ZynqBoard.create_board()
    
    # test read
    res = z.test_reg_read()
    print('test_reg:', res)
    # test write a random value
    z.test_reg_write(123)
    res = z.test_reg_read()
    print('test_reg after write 123:', res)

    n = 1000

    # measure the time taken for write
    start = time.time()
    for i in range(n):
        z.test_reg_write(i)
    end = time.time()
    print(f'Time taken for {n} writes:', end - start, 'seconds')

    # measure the time taken for read
    start = time.time()
    for i in range(n):
        res = z.test_reg_read()
    end = time.time()
    print(f'Time taken for {n} reads:', end - start, 'seconds')

    # measure the time taken for write and read
    start = time.time()
    for i in range(n):
        z.test_reg_write(i)
        res = z.test_reg_read()
    end = time.time()
    print(f'Time taken for {n} writes and reads:', end - start, 'seconds')