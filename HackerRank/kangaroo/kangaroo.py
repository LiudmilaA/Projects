#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the kangaroo function below.
def kangaroo(x1, v1, x2, v2):
    output = "NO"
    if (x1 > x2 and v1 > v2) or (x2 > x1 and v2 > v1):
        output = "NO"
    elif v1 == v2:
        if x1 == x2: output = "YES"
        else: output = "NO"
    elif x1 == x2:
        if v1 != v2: output = "NO"
    elif (x1 - x2)/(v2 - v1) % 1 == 0:
        output = "YES"
    return output

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    x1V1X2V2 = input().split()

    x1 = int(x1V1X2V2[0])

    v1 = int(x1V1X2V2[1])

    x2 = int(x1V1X2V2[2])

    v2 = int(x1V1X2V2[3])

    result = kangaroo(x1, v1, x2, v2)

    fptr.write(result + '\n')

    fptr.close()
