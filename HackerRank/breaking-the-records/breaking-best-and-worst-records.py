#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the breakingRecords function below.
def breakingRecords(scores):
    count_min = 0
    count_max = 0
    highiestScore = scores[0]
    lowestScore = scores[0]
    index = 1
    while index <= n - 1:
        if scores[index] > highiestScore:
            highiestScore = scores[index]
            count_max += 1
        if scores[index] < lowestScore:
            lowestScore = scores[index]
            count_min += 1
        index += 1
    return count_max, count_min

 

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    n = int(input())

    scores = list(map(int, input().rstrip().split()))

    result = breakingRecords(scores)

    fptr.write(' '.join(map(str, result)))
    fptr.write('\n')

    fptr.close()
