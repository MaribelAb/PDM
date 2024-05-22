from rest_framework import routers

from django.urls import path, include

from . import views, models



urlpatterns = [
    path('auth/',include('dj_rest_auth.urls')),
    path('auth/registration/',include('dj_rest_auth.registration.urls')),
    path('getTicket', views.getTicket),
    path('updateTicket/', views.updateTicket),
    path('createForm/', views.create_form),
    path('getForm/', views.getForms),
    path('api-token-auth/', views.CustomAuthToken.as_view(), name='api_token_auth'),
    path('getTarea', views.getTareas),
    path('updateTarea/', views.updateTarea),
    path('crearTarea/', views.crear_tarea),
    path('updateForm/', views.updateForm),
]