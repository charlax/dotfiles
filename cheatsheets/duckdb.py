# Install
# pip install duckdb jupyterlab jupysql pandas matplotlib duckdb-engine

# In notebook
# %load_ext sql
# %sql duckdb://

import duckdb
import pandas as pd

df = pd.DataFrame(...)

result_df = duckdb.sql("select * from df").df()

# See also
# ./duckdb
