#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the utopianTree function below.
def utopianTree(n):
    h = {}
    h[0] = 1
    i = 1
    while i <= 60:
        if i % 2 == 0:
            h[i] = (h[i-1] + 1)
        else: h[i] = (h[i-1]*2)
        i += 1
    return h[n]




if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    t = int(input())

    for t_itr in range(t):
        n = int(input())

        result = utopianTree(n)

        fptr.write(str(result) + '\n')

    fptr.close()
