WITH RECURSIVE recurs AS (
  SELECT point1 AS start_point, 
       point2 AS next_point, 
       cost AS total_cost,
       ARRAY[point1, point2] AS tour,
       1 AS depth
  FROM Trip
  WHERE point1 = 'A'
  
  UNION 
  
  SELECT recurs.start_point,
       t1.point2 AS next_point,
       recurs.total_cost + t1.cost AS total_cost,
       recurs.tour || t1.point2,
       recurs.depth + 1
  FROM recurs
  JOIN Trip t1 ON recurs.next_point = t1.point1
  WHERE NOT t1.point2 = ANY(recurs.tour)
), results as (
select 
	total_cost + (SELECT cost FROM trip WHERE trip.point1 = recurs.next_point AND trip.point2 = 'A') AS total_cost, 
	(tour || ARRAY['A']) AS tour
from recurs
where (depth = 3)
)

SELECT total_cost, tour
FROM results 
ORDER BY total_cost, tour;
