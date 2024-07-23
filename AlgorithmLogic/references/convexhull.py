# from scipy.spatial import ConvexHull
# import numpy as np

# # Helper function to calculate the centroid of a polygon
# def polygon_centroid(vertices):
#     x_coords = vertices[:, 0]
#     y_coords = vertices[:, 1]
#     n = len(vertices)
#     area = 0.0
#     Cx = 0.0
#     Cy = 0.0
#     for i in range(n):
#         xi = x_coords[i]
#         yi = y_coords[i]
#         xi1 = x_coords[(i + 1) % n]
#         yi1 = y_coords[(i + 1) % n]
#         a = xi * yi1 - xi1 * yi
#         area += a
#         Cx += (xi + xi1) * a
#         Cy += (yi + yi1) * a
#     area *= 0.5
#     Cx /= (6.0 * area)
#     Cy /= (6.0 * area)
#     return np.array([Cx, Cy])

# # Function to form clusters
# def form_clusters(points, radius, existing_clusters=None):
#     if existing_clusters is None:
#         clusters = []
#     else:
#         clusters = existing_clusters
    
#     def find_cluster(points):
#         if len(points) == 1:
#             return [(points[0], [points[0]])]
#         elif len(points) == 2:
#             midpoint = np.mean(points, axis=0)
#             if all(np.linalg.norm(point - midpoint) <= radius for point in points):
#                 return [(tuple(points), points)]
#             else:
#                 return [(tuple([points[0]]), [points[0]]), (tuple([points[1]]), [points[1]])]
#         elif len(points) >= 3:
#             try:
#                 hull = ConvexHull(points)
#                 hull_points = points[hull.vertices]
#                 centroid = polygon_centroid(hull_points)
#                 in_cluster = []
#                 out_cluster = []
#                 for point in points:
#                     if np.linalg.norm(point - centroid) <= radius:
#                         in_cluster.append(point)
#                     else:
#                         out_cluster.append(point)
#                 return [(tuple(in_cluster), in_cluster)] + find_cluster(out_cluster)
#             except Exception as e:
#                 print(f"Exception occurred during ConvexHull computation: {e}")
#                 return [(tuple(points), points)]  # Return the current points as a cluster
#         else:
#             return []  # Return an empty list if no points are given
    
#     # Initial clustering or updating existing clusters
#     if not clusters:
#         # Initial clustering
#         for cluster_tuple in find_cluster(points):
#             if len(cluster_tuple[1]) == 1:
#                 centroid = cluster_tuple[1][0]
#             elif len(cluster_tuple[1]) == 2:
#                 centroid = np.mean(cluster_tuple[1], axis=0)
#             else:
#                 centroid = polygon_centroid(np.array(cluster_tuple[1]))

#             clusters.append({
#                 'centroid': centroid,
#                 'points': cluster_tuple[1]
#             })
#     else:
#         # Update clusters with new points
#         for point in points:
#             added_to_cluster = False
#             for cluster in clusters:
#                 centroid = cluster['centroid']
#                 if np.linalg.norm(point - centroid) <= radius:
#                     cluster['points'].append(point)
#                     cluster['centroid'] = np.mean(cluster['points'], axis=0)
#                     added_to_cluster = True
#                     break
            
#             if not added_to_cluster:
#                 clusters.append({
#                     'centroid': point,
#                     'points': [point]
#                 })
    
#     return clusters

# # Example points that exceed the radius of 6 kilometers
# points = np.array([
#     [1, 2], [2, 3], [3, 5], [6, 7], [7, 8], [20, 20], [21, 21], [22, 22]
# ])
# radius = 6  # in kilometers

# # Initial clustering
# clusters = form_clusters(points, radius)
# print("Initial Clusters:")
# for cluster in clusters:
#     print("Centroid:", cluster['centroid'], "Points:", cluster['points'])

# # Adding new points to update clusters
# new_points = np.array([
#     [5, 6], [8, 9], [23, 23]
# ])

# # Updating clusters with new points
# clusters = form_clusters(new_points, radius, existing_clusters=clusters)
# print("\nUpdated Clusters after adding new points:")
# for cluster in clusters:
#     print("Centroid:", cluster['centroid'], "Points:", cluster['points'])


from scipy.spatial import ConvexHull
import numpy as np

# Helper function to calculate the centroid of a polygon
def polygon_centroid(vertices):
    x_coords = vertices[:, 0]
    y_coords = vertices[:, 1]
    n = len(vertices)
    area = 0.0
    Cx = 0.0
    Cy = 0.0
    for i in range(n):
        xi = x_coords[i]
        yi = y_coords[i]
        xi1 = x_coords[(i + 1) % n]
        yi1 = y_coords[(i + 1) % n]
        a = xi * yi1 - xi1 * yi
        area += a
        Cx += (xi + xi1) * a
        Cy += (yi + yi1) * a
    area *= 0.5
    Cx /= (6.0 * area)
    Cy /= (6.0 * area)
    return np.array([Cx, Cy])

# Function to form clusters
def form_clusters(points, radius, existing_clusters=None):
    if existing_clusters is None:
        clusters = []
    else:
        clusters = existing_clusters
    
    def find_cluster(points):
        if len(points) == 1:
            return [(points[0], [points[0]])]
        elif len(points) == 2:
            midpoint = np.mean(points, axis=0)
            if all(np.linalg.norm(point - midpoint) <= radius for point in points):
                return [(tuple(points), points)]
            else:
                return [(tuple([points[0]]), [points[0]]), (tuple([points[1]]), [points[1]])]
        elif len(points) >= 3:
            try:
                hull = ConvexHull(points)
                hull_points = points[hull.vertices]
                centroid = polygon_centroid(hull_points)
                in_cluster = []
                out_cluster = []
                for point in points:
                    if np.linalg.norm(point - centroid) <= radius:
                        in_cluster.append(point)
                    else:
                        out_cluster.append(point)
                return [(tuple(in_cluster), in_cluster)] + find_cluster(out_cluster)
            except Exception as e:
                print(f"Exception occurred during ConvexHull computation: {e}")
                return [(tuple(points), points)]  # Return the current points as a cluster
        else:
            return []  # Return an empty list if no points are given
    
    # Initial clustering or updating existing clusters
    if not clusters:
        # Initial clustering
        for cluster_tuple in find_cluster(points):
            if len(cluster_tuple[1]) == 1:
                centroid = cluster_tuple[1][0]
            elif len(cluster_tuple[1]) == 2:
                centroid = np.mean(cluster_tuple[1], axis=0)
            else:
                centroid = polygon_centroid(np.array(cluster_tuple[1]))

            clusters.append({
                'centroid': centroid,
                'points': cluster_tuple[1]
            })
    else:
        # Update clusters with new points
        for point in points:
            added_to_cluster = False
            for cluster in clusters:
                centroid = cluster['centroid']
                if np.linalg.norm(point - centroid) <= radius:
                    cluster['points'].append(point)
                    cluster['centroid'] = np.mean(cluster['points'], axis=0)
                    added_to_cluster = True
                    break
            
            if not added_to_cluster:
                clusters.append({
                    'centroid': point,
                    'points': [point]
                })
    
    return clusters

# Function to dynamically update clusters as new points arrive
def update_clusters_dynamically(new_points, radius, existing_clusters=None):
    if existing_clusters is None:
        existing_clusters = []
    
    # Update clusters with new points
    clusters = form_clusters(new_points, radius, existing_clusters=existing_clusters)
    
    return clusters

# Example usage:
points = np.array([
    [1, 2], [2, 3], [3, 5], [6, 7], [7, 8], [20, 20], [21, 21], [22, 22]
])
radius = 6  # in kilometers

# Initial clustering
clusters = form_clusters(points, radius)
print("Initial Clusters:")
for cluster in clusters:
    print("Centroid:", cluster['centroid'], "Points:", cluster['points'])

# Simulating continuous arrival of new points
new_points_arrival = [
    np.array([[5, 6], [8, 9], [23, 23]]),
    np.array([[25, 25], [27, 27]]),
    np.array([[30, 30], [35, 35], [40, 40]])
]

# Continuously updating clusters with new points
for new_points in new_points_arrival:
    clusters = update_clusters_dynamically(new_points, radius, existing_clusters=clusters)
    print("\nUpdated Clusters after adding new points:")
    for cluster in clusters:
        print("Centroid:", cluster['centroid'], "Points:", cluster['points'])