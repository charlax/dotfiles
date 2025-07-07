# With jupysql
%load_ext sql

# Run command
%pip install ipywidgets

# ## Template
import pandas as pd
import numpy as np
import duckdb

# Use thousands separator and display 2 decimals
pd.set_option('display.float_format', '{:,.2f}'.format)

# Useful at times, but does not play well with pandas.
import itables
itables.init_notebook_mode()

stats_df = duckdb.sql("select 1").df()
