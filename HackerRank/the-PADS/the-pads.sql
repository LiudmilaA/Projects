SELECT (name || '(' || SUBSTR(occupation, 1, 1) || ')') 
FROM occupations
ORDER BY name;

WITH ad AS (SELECT occupation, 
                   COUNT(occupation) AS output2
            FROM occupations
           GROUP BY occupation)
SELECT ('There are a total of '|| output2 ||' '|| LOWER(occupation) ||'s.')
FROM ad
ORDER BY output2 ASC, occupation; 
                                       