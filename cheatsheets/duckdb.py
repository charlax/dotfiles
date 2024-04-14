import duckdb
import pandas as pd

df = pd.DataFrame(...)

result_df = duckdb.sql("select * from df").df()
