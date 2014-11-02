from django.db import models

# Create your models here.

class House(models.Model):
    name = models.CharField(max_length=64, default="HOUSE")

    def __str__(self):
        return "House: " + self.name

class Room(models.Model):
    rent = models.IntegerField(default=0)
    house = models.ForeignKey(House)

    def __str__(self):
        return "Room: " + list(self.tenant_set.all()).__str__()

    def amount_owed(self):
        return sum(self.utilities.values_list('amount', flat=True))

class Tenant(models.Model):
    name = models.CharField(max_length=64)
    room = models.ForeignKey(Room)

    def __str__(self):
        return self.name

class UtilityChargePeriod(models.Model):
    date = models.DateField()

    def __str__(self):
        return str(self.date.month) + "/" + str(self.date.year)

class Utility(models.Model):
    code = models.CharField(max_length=3)
    name = models.CharField(max_length=32)

    def __str__(self):
        return self.name

class UtilityCharge(models.Model):
    type = models.ForeignKey(Utility)
    amount = models.DecimalField(default=0, max_digits=9, decimal_places=2)
    room = models.ForeignKey(Room, related_name='utilities')
    billPeriod = models.ForeignKey(UtilityChargePeriod, related_name='utilities')


    def __str__(self):
        return str(self.amount) + "(" + self.type.code + ")" + "[" + str(self.billPeriod.date) + "]"
