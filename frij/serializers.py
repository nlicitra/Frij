from rest_framework import serializers
from .models import UtilityCharge, Room, Utility, UtilityChargePeriod

class UtilitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Utility
        fields = ('code', 'name')

class UtilityChargeSerializer(serializers.ModelSerializer):
    type = UtilitySerializer(many=False, required=False)
    class Meta:
        model = UtilityCharge
        fields = ('id', 'type', 'amount')


class RoomUtilitySerializer(serializers.ModelSerializer):
    utilities = UtilityChargeSerializer(many=True)
    model = Room
    class Meta:
        model = Room
        fields = ('rent', 'utilities')

class UtilityChargePeriodSerializer(serializers.ModelSerializer):
    utilities = UtilityChargeSerializer(many=True)

    class Meta:
        model = UtilityChargePeriod
        fields = ('date', 'utilities')