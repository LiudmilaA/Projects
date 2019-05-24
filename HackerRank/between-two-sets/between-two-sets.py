#!/bin/python3

import os
import sys

#
# Complete the getTotalX function below.
#
def getTotalX(a, b):
    count = 0
    i = 1
    while i <= 100:
        condition = True
        for elementA in a:
            if i % elementA != 0:
                condition = False
        for elementB in b:
            if elementB % i != 0:
                condition = False
        if condition == True: 
            count += 1
        i += 1
    return count
  

if __name__ == '__main__':
    f = open(os.environ['OUTPUT_PATH'], 'w')

    nm = input().split()

    n = int(nm[0])

    m = int(nm[1])

    a = list(map(int, input().rstrip().split()))

    b = list(map(int, input().rstrip().split()))

    total = getTotalX(a, b)

    f.write(str(total) + '\n')

    f.close()
