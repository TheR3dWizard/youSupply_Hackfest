from django.db import models

# Create your models here.

class Resource(models.Model):
    Item = models.CharField(max_length=50)

class Cluster(models.Model):
    SystemID = models.IntegerField()

class Node(models.Model):
    ResourceID = models.ForeignKey(Resource, on_delete=models.CASCADE)
    Location = models.PointField()
    ClusterID = models.ForeignKey(Cluster, on_delete=models.PROTECT)
    Quantity = models.IntegerField()

class Route(models.Model):
    RouteID = models.IntegerField()
    StepNumber = models.IntegerField()
    StartNode = models.ForeignKey(Node, on_delete=models.PROTECT)
    EndNode = models.ForeignKey(Node, on_delete=models.PROTECT)
    Item = models.ForeignKey(Resource, on_delete=models.PROTECT)
    isDelivery = models.BooleanField()
    Quantity = models.IntegerField()
    