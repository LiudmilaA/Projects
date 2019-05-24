#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the countApplesAndOranges function below.
def countApplesAndOranges(s, t, a, b, apples, oranges):
    nbrApples = 0
    nbrOranges = 0
    for item in apples:
        if (a + item) >= s and (a + item) <= t:
            nbrApples += 1
    for item in oranges:
        if (b + item) >= s and (b + item) <= t:
            nbrOranges += 1
    print(nbrApples)
    print(nbrOranges)
          


if __name__ == '__main__':
    st = input().split()

    s = int(st[0])

    t = int(st[1])

    ab = input().split()

    a = int(ab[0])

    b = int(ab[1])

    mn = input().split()

    m = int(mn[0])

    n = int(mn[1])

    apples = list(map(int, input().rstrip().split()))

    oranges = list(map(int, input().rstrip().split()))

    countApplesAndOranges(s, t, a, b, apples, oranges)
