from django.contrib import admin
from frij.models import House, Tenant, Room, Utility, UtilityCharge, UtilityChargePeriod

# Register your models here.
admin.site.register(House)
admin.site.register(Tenant)
admin.site.register(Room)
admin.site.register(Utility)
admin.site.register(UtilityCharge)
admin.site.register(UtilityChargePeriod)