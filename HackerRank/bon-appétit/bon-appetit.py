#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the bonAppetit function below.
def bonAppetit(bill, k, b):
    total = sum(bill)
    totalWithoutK = total - bill[k]
    toPay = totalWithoutK/2
    sumToReturn = b - toPay
    if sumToReturn == 0:
        print("Bon Appetit")
    else: 
        print(int(sumToReturn))

if __name__ == '__main__':
    nk = input().rstrip().split()

    n = int(nk[0])

    k = int(nk[1])

    bill = list(map(int, input().rstrip().split()))

    b = int(input().strip())

    bonAppetit(bill, k, b)
