from django.http import HttpResponse
from .models import UtilityCharge, UtilityChargePeriod, UtilityType
from .serializers import UtilityChargeSerializer, UtilityChargePeriodSerializer, UtilityTypeSerializer
from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import permissions, generics, status
from django.http import Http404
import datetime
from dateutil.relativedelta import relativedelta

# Create your views here.
def utility (request):
    try:
        thisMonth = datetime.date.today()
        thisMonth = thisMonth.replace(day=1)
        UtilityChargePeriod.objects.get(date=thisMonth)
    except UtilityChargePeriod.DoesNotExist:
        # Create new charge period & initialize all charges to 0
        newPeriod = UtilityChargePeriod(date=thisMonth)
        newPeriod.save()
        newPeriod.initValues()        
    return render(request, 'frij/utilities.html')

class UtilityTypeService(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        serializer = UtilityTypeSerializer(UtilityType.objects.all(), many=True)
        return Response(serializer.data)

# Return the last 12 months of data
class UtilityDataService(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        try:
            toDate = datetime.date.today()
            fromDate = toDate - relativedelta(years=1)
            periods = UtilityChargePeriod.objects.filter(date__range=(fromDate, toDate)).order_by('date')
            serializer = UtilityChargePeriodSerializer(periods, many=True)
            return Response(serializer.data)
        except:
            return Response() # Just return nothing if invalid

# Return the last 12 months of data
class UtilityGraphDataService(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        try:
            toDate = datetime.date.today()
            fromDate = toDate - relativedelta(years=1)
            periods = UtilityChargePeriod.objects.filter(date__range=(fromDate, toDate))
            graphData = {}
            
            for period in periods:
                index = period.date.month - 1
                for util in period.utilities.all():
                    if graphData.get(util.type.code, None) is None:
                        graphData[util.type.code] = {
                            'utilType': util.type.code,
                            'amounts': [0,0,0,0,0,0,0,0,0,0,0,0]
                        }
                    graphData[util.type.code].get('amounts')[index] = util.amount

            serializer = UtilityGraphDataSerializer(graphData.values(), many=True)
            return Response(serializer.data)
        except:
            return Response() # Just return nothing if invalid

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

