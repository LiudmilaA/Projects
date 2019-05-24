#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the climbingLeaderboard function below.
def climbingLeaderboard(scores, alice):
    rating = []
    for aliceScore in alice:
        while len(scores) > 0 and scores[-1] <= aliceScore:
            del scores[-1]
        rating.append(len(scores) + 1)
    return rating
            
if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    scores_count = int(input())

    scores = list(reversed(sorted(list(set([int(scores_temp) for scores_temp in input().strip().split(' ')])))))
    alice_count = int(input())

    alice = list(map(int, input().rstrip().split()))

    result = climbingLeaderboard(scores, alice)

    fptr.write('\n'.join(map(str, result)))
    fptr.write('\n')

    fptr.close()
