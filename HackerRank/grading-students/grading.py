#!/bin/python3

import os
import sys

#
# Complete the gradingStudents function below.
#
def gradingStudents(grades): 
    student = 0
    gradesRound = grades
    while student <= n-1:
        if grades[student] >= 38:
            nextMultiple5 = round(grades[student]/5 + 0.5)*5
            if (nextMultiple5 - grades[student]) < 3:
               gradesRound[student] = nextMultiple5
        student += 1
    return gradesRound

if __name__ == '__main__':
    f = open(os.environ['OUTPUT_PATH'], 'w')

    n = int(input())

    grades = []

    for _ in range(n):
        grades_item = int(input())
        grades.append(grades_item)

    result = gradingStudents(grades)

    f.write('\n'.join(map(str, result)))
    f.write('\n')

    f.close()
