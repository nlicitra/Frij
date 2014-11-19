from rest_framework import serializers
from .models import UtilityCharge, UtilityType, UtilityChargePeriod

class UtilityTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = UtilityType
        fields = ('code', 'name')

class UtilityChargeSerializer(serializers.ModelSerializer):
    type = UtilityTypeSerializer(many=False, required=False)
    class Meta:
        model = UtilityCharge
        fields = ('id', 'type', 'amount')

class UtilityChargePeriodSerializer(serializers.ModelSerializer):
    utilities = UtilityChargeSerializer(many=True)
    date = serializers.DateField(required=False)
    class Meta:
        model = UtilityChargePeriod
        fields = ('date', 'utilities')