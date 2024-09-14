from django.db import models
from django.contrib.gis.db import models

# Create your models here.

class User(models.Model):
    Username = models.CharField(max_length=50)
    Location = models.PointField()
    Password = models.CharField(max_length=50)
