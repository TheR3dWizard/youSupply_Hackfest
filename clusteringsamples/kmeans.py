import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

# Sample list of coordinates
coordinates = np.array([[0,0],[0,2],[4,2],[1,1],[6,-4],[0,-2],[-4,4.5],[-5,4],[-5,5],[-7,3.0],[-6,4.5],[-2,3], [-1.8,2.8], [-2.2,3.2]])

# Known centroids
centerlist = [[2,0], [-2,0]]  # Changed the second centroid

# Create a KMeans instance with the known centroids
kmeans = KMeans(n_clusters=2, init=np.array(centerlist), n_init=1).fit(coordinates)

# Get the cluster labels
labels = kmeans.labels_

# Create a grid of points
x = np.linspace(min(coordinates[:,0]), max(coordinates[:,0]), 100)
y = np.linspace(min(coordinates[:,1]), max(coordinates[:,1]), 100)
xv, yv = np.meshgrid(x, y)

# Predict the cluster for each point on the grid
grid_labels = kmeans.predict(np.c_[xv.ravel(), yv.ravel()])

# Reshape the grid labels to match the grid
grid_labels = grid_labels.reshape(xv.shape)

# Plot the clusters using imshow
plt.imshow(grid_labels, extent=[min(x), max(x), min(y), max(y)], origin='lower', cmap='viridis', alpha=0.5)

# Plot the original points
plt.scatter(coordinates[:,0], coordinates[:,1], c=labels, cmap='viridis')

# Show the plot
plt.show()