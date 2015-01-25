from django.test import TestCase
from django.test import Client
from frij import models
import datetime
from dateutil.relativedelta import relativedelta
import ast

# Create your tests here.

class UtilityDataServiceTest(TestCase):				
	def setUp(self):
		#Utility Types
		models.UtilityType.objects.create(name="Water", code="WTR")
		models.UtilityType.objects.create(name="Gas", code="GAS")
		models.UtilityType.objects.create(name="Cable", code="CBL")
		models.UtilityType.objects.create(name="Electricity", code="ELC")

		#Utility Periods
		temp_date = datetime.date.today()
		
		for i in range(0,12):
			chargePeriod = models.UtilityChargePeriod.objects.create(date=temp_date)
			for utilityType in models.UtilityType.objects.all():		
				chargePeriod.utilities.create(type=utilityType, amount=55)
			temp_date = temp_date - relativedelta(months=1)


	def test_service(self):
		client = Client()
		response = client.get('/frij/utilities/')
		
		data = ast.literal_eval(response.content)
		# assert the last 12 months have been returned
		self.assertEquals(len(data), 12)
		utilityTypeCount = len(models.UtilityType.objects.all())
		#import pdb; pdb.set_trace()
		temp_date = datetime.date.today() - relativedelta(months=11)
		for period in data:
			# assert dates are in correct order
			self.assertEquals(period['date'], temp_date.strftime('%Y-%m-%d'))
			# assert all utilities are present
			self.assertEquals(len(period['utilities']), utilityTypeCount)
			for charge in period['utilities']:
				# assert amount is correct
				self.assertTrue(charge['amount'] == '55.00')

			temp_date = temp_date + relativedelta(months=1)



