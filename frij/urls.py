from django.conf.urls import url, patterns
from frij import views

urlpatterns = patterns('',
    url(r'^$', views.utility, name='index'),
    url(r'^utilities/(?P<year>[0-9]+)/(?P<month>[0-9]+)/$', views.UtilityChargeList.as_view(), name='roomutil_detail'),
    url(r'^utility/(?P<utilCharge_id>[0-9]+)/$', views.UtilityChargeUpdate.as_view(), name='utilCharge_update'),
)