from django.contrib import admin
from .models import Route,Resource,Node,Cluster
# Register your models here.

admin.site.register(Route)
admin.site.register(Resource)
admin.site.register(Node)
admin.site.register(Cluster)