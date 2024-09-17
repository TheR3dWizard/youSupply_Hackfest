from django.db import models
# Create your models here.

class Resource(models.Model):
    Item = models.CharField(max_length=50)

    def __str__(self):
        return self.Item

class Cluster(models.Model):
    SystemID = models.IntegerField()

    def __str__(self):
        return str(f"In system {self.SystemID}")

class Node(models.Model):
    ResourceID = models.ForeignKey(Resource, on_delete=models.CASCADE)
    Xpos = models.FloatField()
    Ypos = models.FloatField()
    ClusterID = models.ForeignKey(Cluster, on_delete=models.PROTECT)
    Quantity = models.IntegerField()

    class Meta:
        unique_together = ('Xpos', 'Ypos','ResourceID')

    def __str__(self):
        return f"{self.ResourceID} - {self.Xpos} - {self.Ypos} - {self.ClusterID}"

class Route(models.Model):
    RouteID = models.IntegerField()
    StepNumber = models.IntegerField()
    StartNode = models.ForeignKey(Node, on_delete=models.PROTECT,related_name='start_node')
    EndNode = models.ForeignKey(Node, on_delete=models.PROTECT,related_name='end_node')
    Item = models.ForeignKey(Resource, on_delete=models.PROTECT)
    isDelivery = models.BooleanField()
    Quantity = models.IntegerField()

    class Meta:
        unique_together = ('RouteID', 'StepNumber')

    def __str__(self):
        return f"{self.RouteID} - {self.StepNumber} - {self.StartNode} - {self.EndNode} - {self.Item} - {self.isDelivery} - {self.Quantity}"
    