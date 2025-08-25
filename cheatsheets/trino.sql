select count_if(color = 'red')
from toasters;

-- ## Datetime

select date_format(date_trunc('month', from_unixtime(d.created_at / 1000) AT TIME ZONE 'America/New_York'), '%Y-%m-%d') AS month;
select * where created_at_ts between timestamp '2025-07-30 07:05 UTC' and timestamp '2025-07-30 07:42:00 UTC'

-- ## JSON

-- parsing JSON
with config as (select slug,
    cast(json_extract_scalar(parse_config(config), '$.maxDistanceKm') as double) as max_distance_km,
    *
    from data.config_public_dbreplica.configs)

select max_distance_km
from config
where max_distance_km < 9

-- Include other column with group by (first_value require window)
select store_id, min(store_name) from table group by store_id

-- see also
-- ./presto
