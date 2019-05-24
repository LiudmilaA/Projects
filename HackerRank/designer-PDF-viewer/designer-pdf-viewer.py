#!/bin/python3

import math
import os
import random
import re
import sys
import string
from collections import OrderedDict

# Complete the designerPdfViewer function below.
def designerPdfViewer(h, word):
    alphabet = OrderedDict(zip(string.ascii_lowercase, h))
    height = 1
    for letter in word:
        height = max(height, alphabet[letter])
    return height*len(word)

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    h = list(map(int, input().rstrip().split()))

    word = input()

    result = designerPdfViewer(h, word)

    fptr.write(str(result) + '\n')

    fptr.close()
