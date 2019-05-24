#!/bin/python3

import math
import os
import random
import re
import sys
import collections

# Complete the permutationEquation function below.
def permutationEquation(p):
    result = []
    dictP = {}
    count = 1
    for element in p:
        dictP[element] = count
        count += 1
    od = collections.OrderedDict(sorted(dictP.items()))
    for k, v in od.items():
        result.append(od[v])
    return result
    

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    n = int(input())

    p = list(map(int, input().rstrip().split()))

    result = permutationEquation(p)

    fptr.write('\n'.join(map(str, result)))
    fptr.write('\n')

    fptr.close()
