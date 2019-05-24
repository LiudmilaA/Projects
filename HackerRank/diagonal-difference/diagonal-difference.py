#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the diagonalDifference function below.
def diagonalDifference(arr):
    diagonal1 = 0
    diagonal2 = 0
    i = 1
    while i <= n:
        diagonal1 += arr[i-1][i-1]
        diagonal2 += arr[i-1][n-i]
        i += 1
    result = abs(diagonal1 - diagonal2)
    return result


if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    n = int(input())

    arr = []

    for _ in range(n):
        arr.append(list(map(int, input().rstrip().split())))

    result = diagonalDifference(arr)

    fptr.write(str(result) + '\n')

    fptr.close()
