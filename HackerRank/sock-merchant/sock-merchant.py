#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the sockMerchant function below.
def sockMerchant(n, ar):
    socks = {}
    countPair = 0
    for item in ar:
        if item in socks:
            socks[item] += 1
        else:
            socks[item] = 1
    for v in list(socks.values()):
        if v%2 == 0:
            countPair = countPair + v/2
        else:
            countPair = countPair + (v-1)/2
    return int(countPair)

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    n = int(input())

    ar = list(map(int, input().rstrip().split()))

    result = sockMerchant(n, ar)

    fptr.write(str(result) + '\n')

    fptr.close()
