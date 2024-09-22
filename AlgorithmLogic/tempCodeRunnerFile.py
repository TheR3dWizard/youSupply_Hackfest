def plotclusters(self):
        colors = ["r", "g", "b", "y"]
        for idx, cluster in enumerate(self.clusterlist):
            x = [node.x_pos for node in cluster.tolist()]
            y = [node.y_pos for node in cluster.tolist()]
            plt.scatter(x, y, c=colors[idx % len(colors)], label=f"Cluster {idx+1}")
            plt.scatter(cluster.centerxpos, cluster.centerypos, c="k", marker="x")
        plt.xlabel("X Position")
        plt.ylabel("Y Position")
        plt.title("Clusters")
        plt.legend()
        plt.show()