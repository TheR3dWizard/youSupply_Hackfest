from django.db import models
from algorithm.models import Route,Resource
# Create your models here.

class User(models.Model):
    Username = models.CharField(max_length=50)
    CurrentXpos = models.FloatField()
    CurrentYpos = models.FloatField()
    Password = models.CharField(max_length=50)

    def __str__(self):
        return self.Username
class DeliveryVolunteer(models.Model):
    UserID = models.ForeignKey(User, on_delete=models.CASCADE)
    CurrentXpos = models.FloatField()
    CurrentYpos = models.FloatField()
    AcceptedRoute = models.ForeignKey(Route, on_delete=models.PROTECT)

    def __str__(self):
        return self.UserID
class Cart(models.Model):
    cart_id = models.CharField(max_length=100)  
    item = models.ForeignKey(Resource, on_delete=models.CASCADE) 
    quantity = models.IntegerField()
    requested_or_provided = models.CharField(max_length=100)

    class Meta:
        unique_together = ('cart_id', 'item')

    def _str_(self):
        return f"{self.cart_id} - {self.item}"
    

class GeneralUser(models.Model):
    UserID = models.ForeignKey(User, on_delete=models.CASCADE)
    Cart = models.ForeignKey(Cart, on_delete=models.PROTECT)

    def __str__(self):
        return self.UserID
