CREATE TABLE Trip (
    point1 VARCHAR not null,
    point2 VARCHAR not null,
    cost NUMERIC
);

insert into Trip
values
('A', 'B', 10),
('A', 'C', 15),
('A', 'D', 20),
('B', 'D', 25),
('B', 'C', 35),
('C', 'D', 30),
('B', 'A', 10),
('C', 'A', 15),
('D', 'A', 20),
('D', 'B', 25),
('C', 'B', 35),
('D', 'C', 30);

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
WHERE total_cost = (SELECT MIN(total_cost) from results)
ORDER BY tour, total_cost;
