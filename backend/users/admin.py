from django.contrib import admin
from .models import User,DeliveryVolunteer,Cart,GeneralUser
# Register your models here.

admin.site.register(User)
admin.site.register(DeliveryVolunteer)
admin.site.register(Cart)
admin.site.register(GeneralUser)