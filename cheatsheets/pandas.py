# % pip install pandas numpy matplotlib seaborn

from collections import defaultdict

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Create
# ======

# Create from a list of dict
list_of_dicts = [{"a": 1}]
df = pd.DataFrame(list_of_dicts)

# numpy.ndarray to DataFrame
pd.DataFrame(filtered_emails, columns=["email"])

# Dtypes
# ======

# See https://pandas.pydata.org/docs/user_guide/basics.html#basics-dtypes

# CSV
# https://pandas.pydata.org/docs/user_guide/cookbook.html#cookbook-csv
pd.read_csv(path, skiprows=1, dtype=defaultdict(lambda: str))
# Int64 is nullable int
pd.read_csv(path, skiprows=1, dtype={"a": "Int64"})
# Parse dates
pd.read_csv(path, skiprows=1, parse_dates=["created_at"])

# Change number of displayed columns or rows
pd.options.display.max_columns = 6
pd.options.display.max_rows = 1000

# Remove empty strings (does not work with NaN)
df = df[df["latitude"].astype(bool)]

# Drop rows for which latitude is NaN
df.dropna(subset=["latitude"], inplace=True)

# Filter rows (multiple conditions)
df.loc[(df["created_at"] >= "2023-02-22") & (df["created_at"] <= "2023-02-22")]
df.query("object_id == '1' and ts == 0")

# Query by date
df[df["Created UTC"].dt.strftime("%Y-%m-%d") == "2023-01-29"]

# Query null
df.query("column_name.isnull()", engine="python")

# Iterate over rows as dict
for k, row in df.iterrows():
    print(dict(**row))
# or:
# https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_dict.html
for row in df.to_dict("records"):
    print(dict(**row))

# Groupby iteration
for group_name, grouped in df.groupby("object_id"):
    print(group_name)  # first object's object_id
    for pos, row in grouped.iterrows():  # iterrows yield tuples of (index, row)
        print(row)
        print(row["name"])

# Unique string column that might contain whitespace, sorted alphabetically,
# returned as Python list
np.sort(df[df["istrue"] == True]["city"].str.strip().unique()).tolist()

# Sort by column value
df.sort_values("counts", ascending=False)

# Check if value is empty
pd.isnull(v)

# Dates
# =====
df["week"] = df["Date"].dt.isocalendar().week

# Format
# ======

# Use a gradient on a per column basis
# https://pandas.pydata.org/docs/reference/api/pandas.io.formats.style.Styler.background_gradient.html
df.style.background_gradient(axis=0)

# Use gradient only for numerical columns
numerical_cols = df.select_dtypes(include=[np.number]).columns
df[numerical_cols] = (
    df[numerical_cols].apply(pd.to_numeric, errors="coerce").astype("Int64")
)
df.style.format("{:,.0f}", subset=numerical_cols).background_gradient(
    cmap="viridis", subset=numerical_cols
)

# Graph and visualization
# =======================

# Display a grid of distribution plot for revenue by owner
sns.displot(df, x="revenue", col="owner")

# Groupby
# =======

# groupby then get size as dataframe
df.groupby("name").size().reset_index(name="counts")

# groupby day
df.groupby(by=df["Created UTC"].dt.date).size().reset_index(name="counts")
# groupby day-hour
df.groupby(by=df["Created UTC"].dt.floor("H")).size().reset_index(name="counts")
# groupby then value counts
df.groupby("column_name")["column_to_count"].value_counts()

# groupby then sum
df.groupby("Date").sum()

# groupby then get means, median, etc.
df.groupby("date")[["revenue"]].describe()

# groupby then aggregate into a set
df.groupby("phone")["week"].agg(set).reset_index()

# Join & merge
# ============

# Very useful link
"https://pandas.pydata.org/docs/getting_started/comparison/comparison_with_sql.html#compare-with-sql-join"

pd.merge(df1, df2, on="key", how="right")

# Querying (indexing and selecting)
# =================================

df[df.appname == "toaster"]
df[df.appname.isin(["toaster1", "toaster2"])]
df[~df.appname.isin(["toaster1", "toaster2"])]

# Query using SQL with DuckDB https://duckdb.org/docs/api/python/overview
# pip install duckdb
import duckdb

pandas_df = pd.DataFrame({"a": [42]})
duckdb.sql("SELECT * FROM pandas_df")

# https://pandas.pydata.org/pandas-docs/dev/user_guide/indexing.html#boolean-indexing
# Multiple conditions
df = df[(df["is_test"] != True) & (df["is_cancelled"] == False)]

# See also
# ========
"https://pandas.pydata.org/Pandas_Cheat_Sheet.pdf"
"https://www.webpages.uidaho.edu/~stevel/cheatsheets/Pandas%20DataFrame%20Notes_12pages.pdf"
