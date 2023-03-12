# Add this at beginning of jupyter notebook:
# %matplotlib notebook

import matplotlib.pyplot as plt


fig, ax = plt.subplots()
ax.scatter(x, y)
ax.scatter([0, 1, 2], [0, 2, 4])
