from django.conf.urls import patterns, include, url
from django.contrib import admin

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^frij/', include('frij.urls', namespace="frij")),
)

handler404 = 'config.views.notfound'