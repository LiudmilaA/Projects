#!/bin/python3

import math
import os
import random
import re
import sys
import collections

# Complete the migratoryBirds function below.
def migratoryBirds(arr):
    maxCnt = {}
    for element in arr:
        if element in maxCnt:
            maxCnt[element] += 1
        else:
            maxCnt[element] = 1
    od = collections.OrderedDict(sorted(maxCnt.items()))
    output = max(od, key=od.get)
    return output 


if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    arr_count = int(input().strip())

    arr = list(map(int, input().rstrip().split()))

    result = migratoryBirds(arr)

    fptr.write(str(result) + '\n')

    fptr.close()
