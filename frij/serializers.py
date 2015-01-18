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

    def update(self, instance, validated_data):
        utility_data = validated_data.pop('utilities')
        utilities = instance.utilities

        for utility in utilities.all():
            curIndex = -1
            for index, utilType in enumerate(utility_data):
                if utilType['type']['code'] == utility.type.code:
                    curIndex = index
                    break   
            if curIndex > -1:
                utility.amount = utility_data[curIndex].get('amount', utility.amount)
                utility.save()

        return instance