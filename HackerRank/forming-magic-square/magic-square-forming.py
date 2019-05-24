#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the formingMagicSquare function below.
def formingMagicSquare(s):
    magicSquares = []
    magicSquares.append([8,1,6,3,5,7,4,9,2])
    magicSquares.append([6,7,2,1,5,9,8,3,4])
    magicSquares.append([4,3,8,9,5,1,2,7,6])
    magicSquares.append([2,9,4,7,5,3,6,1,8])
    magicSquares.append([8,3,4,1,5,9,6,7,2])
    magicSquares.append([6,1,8,7,5,3,2,9,4])
    magicSquares.append([4,9,2,3,5,7,8,1,6])
    magicSquares.append([2,7,6,9,5,1,4,3,8])
    
    index = [0, 1, 2]
    inputSquare = []
    for i in index:
        for j in index:
            inputSquare.append(s[i][j])
    costs = []
    for item in magicSquares:
        cost = 0
        for i in range(9):
                cost = cost + abs(item[i] - inputSquare[i])
        costs.append(cost)
    return min(costs)
        
   

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    s = []

    for _ in range(3):
        s.append(list(map(int, input().rstrip().split())))

    result = formingMagicSquare(s)

    fptr.write(str(result) + '\n')

    fptr.close()
