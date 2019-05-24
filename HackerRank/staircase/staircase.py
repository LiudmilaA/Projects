#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the staircase function below.
def staircase(n):
    spase = ' '
    stair = '#'
    i = 1
    while i <= n:
        print((n-i)*spase + i*stair)
        i += 1

if __name__ == '__main__':
    n = int(input())

    staircase(n)
