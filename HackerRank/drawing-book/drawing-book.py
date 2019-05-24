#!/bin/python3

import os
import sys

#
# Complete the pageCount function below.
#
def pageCount(n, p):
    if p == 1: count = 0
    elif (n-p) == 1 and n%2 == 0: count = 1
    elif p < n/2:
        if p%2 ==0: count = p/2
        else: count = (p-1)/2
    else:
        if (n-p)%2 ==0: count = (n-p)/2
        else: count = (n-p-1)/2
    return int(count)
   

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    n = int(input())

    p = int(input())

    result = pageCount(n, p)

    fptr.write(str(result) + '\n')

    fptr.close()
