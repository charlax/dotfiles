import pandas as pd

df = pd.read_csv("./event_logs.csv")
data = df[["when"]]

# Group by hour and plot
data.groupby(pd.Grouper(key="when", freq="2H")).size().plot()
