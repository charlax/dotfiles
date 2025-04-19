# With jupysql
%load_ext sql

# Run command
%pip install ipywidgets

# ## Template
import pandas as pd
import numpy as np
import duckdb

import itables

itables.init_notebook_mode()

stats_df = duckdb.sql("select 1").df()
