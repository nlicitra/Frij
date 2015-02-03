from django.db import models

class UtilityChargePeriod(models.Model):
    date = models.DateField()

    def __str__(self):
        return str(self.date.month) + "/" + str(self.date.year)

    def initValues(self):
        if len(self.utilities.all()) == 0:
            for utilType in UtilityType.objects.all():
                self.utilities.create(type=utilType, amount=0)

class UtilityType(models.Model):
    code = models.CharField(max_length=3)
    name = models.CharField(max_length=32)

    def __str__(self):
        return self.name

class UtilityCharge(models.Model):
    type = models.ForeignKey(UtilityType)
    amount = models.DecimalField(default=0, max_digits=9, decimal_places=2)
    billPeriod = models.ForeignKey(UtilityChargePeriod, related_name='utilities')


    def __str__(self):
        return str(self.amount) + "(" + self.type.code + ")" + "[" + str(self.billPeriod.date) + "]"
