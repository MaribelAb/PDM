import json
from django.http import JsonResponse
from django.shortcuts import render
from rest_framework import viewsets, permissions
from centaurApp.models import Agente, Formulario, Usuario, Ticket
from centaurApp.serializers import TicketSerializer, UserSerializer , AgentSerializer
from rest_framework import status,views, response
from rest_framework import authentication
from django.contrib.auth.models import User
from django.contrib.auth import logout ,authenticate, login 
from rest_framework.authtoken.models import Token
from .serializers import  FormularioSerializer, UserSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAdminUser
from django.contrib.auth.models import User
from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.views.decorators.csrf import csrf_exempt
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated


# Create your views here.

class UserRecordView(APIView):
    """
    API View to create or get a list of all the registered
    users. GET request returns the registered users whereas
    a POST request allows to create a new user.
    """
    permission_classes = [IsAdminUser]

    def get(self, format=None):
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid(raise_exception=ValueError):
            serializer.create(validated_data=request.data)
            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            {
                "error": True,
                "error_msg": serializer.error_messages,
            },
            status=status.HTTP_400_BAD_REQUEST
        )




#class TicketViewSet(viewsets.ModelViewSet):
#    queryset = Ticket.objects.all()
#    serializer_class = TicketSerializer

@csrf_exempt
def getTicket(request):
    if request.method == 'GET':
        try:
            app = Ticket.objects.all()
            serializer = TicketSerializer(app, many=True)
            return JsonResponse({'data': serializer.data, 'message': 'Data sent successfully'})
        except json.JSONDecodeError as e:
            # Handle JSON decode error
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
    else:
        # Return an error for other HTTP methods
        return JsonResponse({'error': 'Only GET requests are allowed'}, status=405)

@csrf_exempt
def updateTicket(request):
    if request.method == 'PUT':
        
        data = json.loads(request.body.decode('utf-8'))
        ticket_id = data.get('id')
        
        try:
            ticket = Ticket.objects.get(id=ticket_id)
        except Ticket.DoesNotExist:
            return JsonResponse({'error': 'Ticket does not exist'}, status=404)
        
        serializer = TicketSerializer(ticket, data=data)
        
        if serializer.is_valid():
            serializer.save()
            return JsonResponse({'message': 'Ticket updated successfully'}, status=200)
        return JsonResponse(serializer.errors, status=400)
    else:
        return JsonResponse({'error': 'Only PUT requests are allowed'}, status=405)

@api_view(['POST'])
def postTicket(request):
    serializer = TicketSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
    return Response(serializer.data)

@csrf_exempt
def prueba(request):
    msg = 'nok'
    if request.method == 'POST':
    # Assuming your Flutter app sends JSON data
        try:
            # Load the JSON data from the request body
            data = json.loads(request.body.decode('utf-8'))
            
            # Now you can access the data as a Python dictionary
            # For example, if your Flutter app sends a key 'name', you can access it like this:
            titulo = data.get('titulo')
            descripcion = data.get('descripcion')
            solicitante = data.get ('solicitante')

            nuevo = Ticket.objects.create(titulo = titulo, descripcion = descripcion, solicitante = solicitante)
            #nuevo.save
            # Process the data as needed
            # For example, you could save it to a database
            
            return JsonResponse(nuevo, {'message': 'Data received successfully'}, safe=False)
        
        except json.JSONDecodeError as e:
            # Handle JSON decode error
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        
    else:
            # Return an error for other HTTP methods
        return JsonResponse({'error': 'Only POST requests are allowed'}, status=405)
    


class UserViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAdminUser,]
    authentication_classes = [authentication.BasicAuthentication,]

class AgentViewSet(viewsets.ModelViewSet):
  queryset = Agente.objects.all()  
  permission_classes = [permissions.AllowAny]
  serializer_class = AgentSerializer

class LoginView(views.APIView):
    permission_classes = [permissions.AllowAny]
    def post(self, request):
        # Recuperamos las credenciales y autenticamos al usuario
        username2= request.data.get('username', None)
        password2 = request.data.get('password', None)
        if username2 is None or password2 is None:
            return response.Response({'message': 'Please provide both username and password'},status=status.HTTP_400_BAD_REQUEST)
        user2 = authenticate(username=username2, password=password2)
        if not user2:
            return response.Response({'message': 'Usuario o Contraseña incorrecto !!!! '},status=status.HTTP_404_NOT_FOUND)

        token, _ = Token.objects.get_or_create(user=user2)
        # Si es correcto añadimos a la request la información de sesión
        if user2:
            # para loguearse una sola vez
            # login(request, user)
            return response.Response({'message':'usuario y contraseña correctos!!!!'},status=status.HTTP_200_OK)
            #return response.Response({'token': token.key}, status=status.HTTP_200_OK)

        # Si no es correcto devolvemos un error en la petición
        return response.Response(status=status.HTTP_404_NOT_FOUND)        

class LogoutView(views.APIView):
    authentication_classes = [authentication.TokenAuthentication]
    def post(self, request):        
        request.user.auth_token.delete()
        # Borramos de la request la información de sesión
        logout(request)
        # Devolvemos la respuesta al cliente
        return response.Response({'message':'Sessión Cerrada y Token Eliminado !!!!'},status=status.HTTP_200_OK)


@csrf_exempt
def create_form(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        print(data)
        serializer = FormularioSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data, status=status.HTTP_201_CREATED)
        return JsonResponse(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    else:
        return JsonResponse({'message': 'Método no permitido'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)
        
@csrf_exempt
def getForms(request):
    if request.method == 'GET':
        try:
            app = Formulario.objects.all()
            serializer = FormularioSerializer(app, many=True)
            return JsonResponse({'data': serializer.data, 'message': 'Data sent successfully'})
        except json.JSONDecodeError as e:
        # Handle JSON decode error
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
    else:
        # Return an error for other HTTP methods
        return JsonResponse({'error': 'Only GET requests are allowed'}, status=405)