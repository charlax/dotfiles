-- get logs from application load balancer, group by day

select substr(time, 1, 10) as day, count(*) as number
from alb_logs
where 1=1
and time > to_iso8601(TIMESTAMP '2020-07-25 00:00:00')
and time < to_iso8601(TIMESTAMP '2020-08-15 00:00:00')
and request_url like '%/truc'
group by substr(time, 1, 10)
order by day asc;

-- another way:

SELECT day_of_year(from_iso8601_timestamp(time)) as day, count(*) as count
FROM alb_logs
WHERE 1 = 1
AND time > to_iso8601(current_timestamp - interval '40' day)
AND request_url like '%%/truc%%'
GROUP BY 1
LIMIT 100
