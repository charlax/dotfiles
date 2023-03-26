import pandas as pd

# Change number of displayed columns or rows
pd.options.display.max_columns = 6
pd.options.display.max_rows = 1000

# Remove empty strings (does not work with NaN)
df = df[df["latitude"].astype(bool)]

# Drop NaN
df.dropna(subset=["latitude"], inplace=True)

# Filter rows (multiple conditions)
df.loc[(df["created_at"] >= "2023-02-22") & (df["created_at"] <= "2023-02-22")]
df.query("object_id == '1' and ts == 0")

# Query by date
df[df["Created UTC"].dt.strftime("%Y-%m-%d") == "2023-01-29"]

# Query null
df.query("column_name.isnull()", engine="python")

# Groupby iteration
for group_name, grouped in df.groupby("object_id"):
    print(group_name)  # first object's object_id
    for pos, row in grouped.iterrows():  # iterrows yield tuples of (index, row)
        print(row)
        print(row["name"])

# groupby then get size as dataframe
df.groupby("name").size().reset_index(name="counts")

# groupby day
df.groupby(by=df["Created UTC"].dt.date).size().reset_index(name="counts")
# gropuby day-hour
df.groupby(by=df["Created UTC"].dt.floor("H")).size().reset_index(name="counts")

# groupby then sum
df.groupby("Date").sum()

# Check if value is empty
pd.isnull(v)

# See also:
"https://pandas.pydata.org/Pandas_Cheat_Sheet.pdf"
"https://www.webpages.uidaho.edu/~stevel/cheatsheets/Pandas%20DataFrame%20Notes_12pages.pdf"
