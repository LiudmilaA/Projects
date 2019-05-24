#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the dayOfProgrammer function below.
def dayOfProgrammer(year):
    if year == 1918:
        output = '26.09.' + str(year)
    if year < 1918:
        if year%4 == 0:
            output = '12.09.' + str(year)
        else: output = '13.09.' + str(year)
    if year > 1918:
        if year%400 == 0 or (year%4 == 0 and year%100 != 0):
            output = '12.09.' + str(year)
        else: output = '13.09.' + str(year)
    return output

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    year = int(input().strip())

    result = dayOfProgrammer(year)

    fptr.write(result + '\n')

    fptr.close()
