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

# Groupby iteration
for group_name, grouped in df.groupby("object_id"):
    print(group_name)  # first object's object_id
    for pos, row in grouped.iterrows():  # iterrows yield tuples of (index, row)
        print(row)
        print(row["name"])
