select count_if(color = 'red')
from toasters;

-- ## Datetime

select date_format(date_trunc('month', from_unixtime(d.created_at / 1000) AT TIME ZONE 'America/New_York'), '%Y-%m-%d') AS month;

-- ## JSON

-- parsing JSON
with config as (select slug,
    cast(json_extract_scalar(parse_config(config), '$.maxDistanceKm') as double) as max_distance_km,
    *
    from data.config_public_dbreplica.configs)

select max_distance_km
from config
where max_distance_km < 9

-- see also
-- ./presto
