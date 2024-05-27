from rest_framework import routers

from django.urls import path, include

from . import views, models



urlpatterns = [
    path('auth/',include('dj_rest_auth.urls')),
    path('auth/registration/',include('dj_rest_auth.registration.urls')),
    path('postTicket/', views.postTicket),
    path('getTicket/', views.getTicket),
    path('updateTicket/', views.updateTicket),
    path('createForm/', views.create_form),
    path('getForm/', views.getForms),
    path('api-token-auth/', views.CustomAuthToken.as_view(), name='api_token_auth'),
    path('getTarea', views.getTareas),
    path('updateTarea/', views.updateTarea),
    path('crearTarea/', views.crear_tarea),
    path('updateForm/', views.updateForm),
    path('updateFormVis/', views.updateFormVisibility),
    path('getUsers/', views.user_list),
    path('getChoices/', views.ticket_choices),
    path('getClients/', views.client_list),
    path('allUsers/', views.getAllUsers),
]