import polars

# Group by
# https://labs.quansight.org/blog/dataframe-group-by
pl.col("views").filter(pl.col("sales") > pl.mean("sales")).max()
df.group_by("id").agg(pl.col("views").filter(pl.col("sales") > pl.mean("sales")).max())

# See also
"./pandas.py"
