-- FILTER can be used for pivot tables https://duckdb.org/docs/sql/query_syntax/filter
SELECT
    count(i) FILTER (year = 2022) AS "2022",
    count(i) FILTER (year = 2023) AS "2023",
    count(i) FILTER (year = 2024) AS "2024",
    count(i) FILTER (year = 2025) AS "2025",
    count(i) FILTER (year IS NULL) AS "NULLs"
FROM stacked_data;

-- see also
-- ./duckdb
-- ./duckdb.py
