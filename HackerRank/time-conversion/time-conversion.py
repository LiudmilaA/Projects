#!/bin/python3

import os
import sys

#
# Complete the timeConversion function below.
#
def timeConversion(s):
    heur = int(s[0:2])
    ind = s[-2:]
    if ind == 'AM':
        if heur == 12:
            heur = '00'
            res = heur + s[2:8]
        else:
            res = s[0:8]
    else: 
        if heur == 12:
            res = s[0:8]
        else:
            heur = heur + 12
            res = str(heur) + s[2:8]
    return res

if __name__ == '__main__':
    f = open(os.environ['OUTPUT_PATH'], 'w')

    s = input()

    result = timeConversion(s)

    f.write(result + '\n')

    f.close()
