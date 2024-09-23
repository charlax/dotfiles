# Install
# pip install duckdb jupyterlab jupysql pandas matplotlib duckdb-engine

# In notebook
# %load_ext sql
# %sql duckdb://

import duckdb
import pandas as pd

df = pd.DataFrame(...)

result_df = duckdb.sql("select * from df").df()

# With jupysql
import duckdb
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

%load_ext sql
conn = duckdb.connect()
%sql conn --alias duckdb

# See also
# ./duckdb
