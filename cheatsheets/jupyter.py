# For jupysql:
# %pip install jupysql duckdb-engine --quiet

# With jupysql (https://jupysql.ploomber.io/en/latest/quick-start.html)
# %load_ext sql

# %sql select * from example

# %%sql
# select * -- multiline
# from example

# Explore a table:
# %sqlcmd explore --table "yellow_tripdata_2021.parquet"

# Run command
# %pip install ipywidgets

# ## Template
import pandas as pd
import numpy as np
import duckdb

# Use thousands separator and display 2 decimals
pd.set_option("display.float_format", "{:,.2f}".format)

# Useful at times, but does not play well with pandas.
import itables

itables.init_notebook_mode()

stats_df = duckdb.sql("select 1").df()

# Increase number of rows displayed for a pandas dataframe
pd.options.display.max_rows = 4000

# For a single display:
with pd.option_context("display.max_rows", None):
    print(df)

# Increase number of rows displayed for duckdb
duckdb.query("SELECT * FROM table").show(max_rows=1000)

# See also
# ./jupyter CLI
# ./duckdb.py
# ./pandas.py
# ./matplotlib.py
