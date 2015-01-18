from django.conf.urls import url, patterns
from frij import views

urlpatterns = patterns('',
    url(r'^$', views.utility, name='index'),
    url(r'^utilities/$', views.UtilityDataService.as_view(), name='utilities_view'),
    url(r'^utilities/(?P<year>[0-9]+)/(?P<month>[0-9]+)/$', views.UtilityChargeService.as_view(), name='roomutil_detail'),
    url(r'^utilities/types/$', views.UtilityTypeService.as_view(), name='utilities_types'),
)