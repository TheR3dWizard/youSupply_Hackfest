class ClusteringObject:
    """
    represents the class that performs clustering on a list of nodes (system)
    (flawed) clustering logic is contained in the .mapsinkstosource()
    .getclusterslist() to return the list after clustering

    TODO: Need logic for grouping clusters together
    TODO: New method that returns avg cluster size to measure cluster efficiency?
    TODO: Do we really need a class for this? or can this be inside the Cluster class itself?
    """


    def __init__(self, systemofnodes: System) -> None:
        self.clusterlist:List[Cluster] = [] 
        self.sinknodes = []
        self.sourcenodes = []
        self.freepool = []
        self.systemofnodes = systemofnodes
        self.categorizenodes(systemofnodes.getnodes())
        # for sourcenode in self.sourcenodes:
        #     self.clusterlist.append(Cluster(sourcenode))

        # self.mapsinkstosource()

    # This function is flawed, it just maps the nearest source to a sink, @Akash remove it if its not needed
    def mapsinkstosource(self):
        for sinknode in self.sinknodes:
            mindistance = float("inf")
            nearestsource = None
            for clusterobject in self.clusterlist:
                newdistance = clusterobject.getdistance(sinknode)
                if newdistance < mindistance:
                    mindistance = newdistance
                    nearestsource = clusterobject

            nearestsource.sinknodes.append(sinknode)

    #creates clusters based on spectral clustering and adds nodes to the clusters
    def spectralclustering(self):
        spc = SpectralClustering(n_clusters=8, random_state=42, affinity='nearest_neighbors')
        spc.fit(self.systemofnodes.listofpositions)
        cluster_labels = spc.labels_
        clusters = defaultdict(list)

        for i, label in enumerate(cluster_labels):
            clusters[label].append(self.systemofnodes.getnodes()[i])

        for cluster_nodes in clusters.values():
            sourcenode = cluster_nodes[0]
            cluster = Cluster(sourcenode)
            for node in cluster_nodes[1:]:
                if node.nodetype == "Sink":
                    #remove nodes from clusteringobject when theyre added to a cluster
                    self.sinknodes.remove(node)
                    cluster.addsink(node)
                else:
                    self.sourcenodes.remove(node)
                    cluster.addsource(node)
            self.clusterlist.append(cluster)

    def createfreepool(self) -> System:
        for cluster in self.clusterlist:
            self.freepool += cluster.getfeasible()
        return System(self.freepool)


    def getclusterslist(self):
        return self.clusterslist


