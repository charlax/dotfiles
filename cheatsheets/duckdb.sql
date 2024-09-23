-- SUMMARIZE is equivalent to df.describe()
SUMMARIZE tablename;

-- FILTER can be used for pivot tables https://duckdb.org/docs/sql/query_syntax/filter
SELECT
    count(i) FILTER (year = 2022) AS "2022",
    count(i) FILTER (year = 2023) AS "2023",
    count(i) FILTER (year = 2024) AS "2024",
    count(i) FILTER (year = 2025) AS "2025",
    count(i) FILTER (year IS NULL) AS "NULLs"
FROM stacked_data;

SELECT
    count(*) AS total_rows,
    count(*) FILTER (i <= 5) AS lte_five,
    count(*) FILTER (i % 2 = 1) AS odds
FROM generate_series(1, 10) tbl(i);

-- function chaining
SELECT
     ('Make it so')
          .upper()
          .string_split(' ')
          .list_aggr('string_agg','.')
          .concat('.') AS im_not_messing_around_number_one;

-- PIVOT https://duckdb.org/docs/sql/statements/pivot.html
PIVOT Cities
ON Year
USING sum(Population)
GROUP BY Country;

-- GROUP BY ROLLUP
FROM toasters
-- "total" shows up as NULL
SELECT coalesce(color, 'TOTAL'), count()
GROUP BY ROLLUP (color)

-- see also

-- friendly sql features: https://duckdb.org/docs/sql/dialect/friendly_sql

-- ./duckdb
-- ./duckdb.py
