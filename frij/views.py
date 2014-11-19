from django.http import HttpResponse
from .models import UtilityCharge, UtilityChargePeriod
from .serializers import UtilityChargeSerializer, UtilityChargePeriodSerializer
from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import permissions, generics, status
from django.http import Http404
import datetime

# Create your views here.
def test(request):
    return render(request, 'frij/test.html')

def utility (request):
    return render(request, 'frij/utilities.html')

def notfound(request):
    return HttpResponse("That page doesn't even exist, stupid")

class UtilityChargeService(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request, month, year):
        try:
            date = datetime.date(int(year), int(month), 1)
            period = UtilityChargePeriod.objects.get(date=date)
            serializer = UtilityChargePeriodSerializer(period)
            return Response(serializer.data)
        except UtilityChargePeriod.DoesNotExist:
            return Response() # Just return nothing if invalid

    def put(self, request, year, month):
        try:
            date = datetime.date(int(year), int(month), 1)
            period = UtilityChargePeriod.objects.get(date=date)
            serializer = UtilityChargePeriodSerializer(period, request.DATA)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except UtilityChargePeriod.DoesNotExist:
            raise Http404


class UtilityChargeUpdate(generics.UpdateAPIView):
    model = UtilityCharge
    serializer_class = UtilityChargeSerializer
    lookup_url_kwarg = 'utilCharge_id'
    permission_classes = [permissions.AllowAny]

