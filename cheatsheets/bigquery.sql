-- https://cloud.google.com/bigquery/docs/introduction-sql
-- GoogleSQL: https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax

-- supports pipe syntax
FROM mydataset.produce
|> WHERE sales > 0;

-- pipe syntax with join
FROM mydataset.produce
|> WHERE sales > 0
|> AGGREGATE SUM(sales) AS total_sales, COUNT(*) AS num_sales
   GROUP BY item
|> JOIN mydataset.item_data USING(item);

-- extra select features
select * except (order_id) from orders;

-- PIVOT
SELECT * FROM
  Produce
  PIVOT(SUM(sales) FOR quarter IN ('Q1', 'Q2', 'Q3', 'Q4'));

-- PIVOT with custom columns, and different aggregations (count)
SELECT * FROM
  (SELECT product, sales, quarter FROM Produce)
  PIVOT(SUM(sales) AS total_sales, COUNT(*) AS num_records FOR quarter IN ('Q1', 'Q2'));

-- UNPIVOT rotates columns into rows
WITH Produce AS (
  SELECT 'Kale' as product, 51 as Q1, 23 as Q2, 45 as Q3, 3 as Q4 UNION ALL
  SELECT 'Apple', 77, 0, 25, 2)
SELECT * FROM Produce
/*---------+----+----+----+----*
 | product | Q1 | Q2 | Q3 | Q4 |
 +---------+----+----+----+----+
 | Kale    | 51 | 23 | 45 | 3  |
 | Apple   | 77 | 0  | 25 | 2  |
 *---------+----+----+----+----*/

SELECT * FROM Produce
UNPIVOT(sales FOR quarter IN (Q1, Q2, Q3, Q4))

/*---------+-------+---------*
 | product | sales | quarter |
 +---------+-------+---------+
 | Kale    | 51    | Q1      |
 | Kale    | 23    | Q2      |
 | Kale    | 45    | Q3      |
 | Kale    | 3     | Q4      |
 | Apple   | 77    | Q1      |
 | Apple   | 0     | Q2      |
 | Apple   | 25    | Q3      |
 | Apple   | 2     | Q4      |
 *---------+-------+---------*/

 /* ## GROUP BY */

GROUP BY ALL
GROUP BY GROUPING SETS
GROUP BY ROLLUP
GROUP BY CUBE

/* ## Windows

https://cloud.google.com/bigquery/docs/reference/standard-sql/window-function-calls#def_window_spec
 */

SELECT
  item,
  RANK() OVER (PARTITION BY category ORDER BY purchases DESC) as rank
FROM Produce
WHERE Produce.category = 'vegetable'
-- QUALIFY filters the results of window functions
QUALIFY rank <= 3;

/* ## ML
*/

-- https://cloud.google.com/bigquery/docs/reference/standard-sql/bigqueryml-syntax-predict
CREATE MODEL
  `mydataset.mymodel1`
OPTIONS
  (model_type='linear_reg',
    input_label_cols=['label'],
  ) AS
SELECT
  label,
  input_column1
FROM
  `mydataset.mytable`

SELECT
  *
FROM
  ML.PREDICT(MODEL `mydataset.mymodel`,
    (
    SELECT
      label,
      column1,
      column2
    FROM
      `mydataset.mytable`))
