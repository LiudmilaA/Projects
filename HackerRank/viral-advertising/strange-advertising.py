#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the viralAdvertising function below.
def viralAdvertising(n):
    nbrDays = 1
    total = 0
    shared = 5
    while nbrDays <= n:
        liked = int(round((shared/2) - 0.4))
        total = total + liked
        shared = liked * 3
        nbrDays += 1
    return total

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    n = int(input())

    result = viralAdvertising(n)

    fptr.write(str(result) + '\n')

    fptr.close()
