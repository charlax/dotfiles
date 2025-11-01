# Add this at beginning of jupyter notebook:
# %matplotlib notebook

import matplotlib.pyplot as plt


fig, ax = plt.subplots()
ax.scatter(x, y)
ax.scatter([0, 1, 2], [0, 2, 4])

# Relatively complicated graph
df["date"] = pd.to_datetime(df["date"])
df = df.sort_values("date").reset_index(drop=True)
fig, ax = plt.subplots(figsize=(14, 6))
# Plot bars using actual timestamps for x-axis
bar_width = pd.Timedelta(days=1)
ax.bar(
    df["date"], df["height_value"], width=bar_width, edgecolor="black", linewidth=0.5
)

ax.set_xlabel("Time")
ax.set_ylabel("Height value")
ax.set_title("The title")
ax.set_ylim(0, 2.5)
ax.grid(axis="y", alpha=0.3)
fig.autofmt_xdate()

plt.tight_layout()
plt.show()

# See also
# ./pandas.py
# ./jupyter.py
