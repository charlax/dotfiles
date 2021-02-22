-- distinct on is a postgres feature
select distinct on (order_id) order_id, created_at, status
from order_statuses
order by order_id, created_at desc, status;

-- inspired by https://www.geekytidbits.com/postgres-distinct-on/
