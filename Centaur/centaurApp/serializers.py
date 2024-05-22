from rest_framework import serializers
from centaurApp.models import  Ticket, Usuario
from rest_framework.authtoken.models import Token
from rest_framework.validators import UniqueTogetherValidator
from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from .models import Contenido, Formulario, Campo, Opcion, Tarea
from django.contrib.auth.models import Group
from django.contrib.auth import get_user_model

#class NewRegisterSerializer(RegisterSerializer):
#    nombre = serializers.CharField()
#    apellido = serializers.CharField()

#    def custom_signup(self, request, user):
#        user = request.data['nombre']
#        user = request.data['apellido']
#        user.save()

#class NewLoginSerializer(LoginSerializer):
#    pass

User = get_user_model()



class GroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = ['name']

class UserSerializer(serializers.ModelSerializer):
    groups = GroupSerializer(many=True, read_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'groups']


#class UserSerializer(serializers.ModelSerializer):

 #   def create(self, validated_data):
  #      user = Usuario.objects.create_user(**validated_data)
   #     return user

 #   class Meta:
 #       model = Usuario
 #       fields = (
 #           'username',
 #           'nombre',
 #           'apellido',
 #           'email',
 #           'password',
 #       )
 #       validators = [
 #           UniqueTogetherValidator(
 #               queryset=Usuario.objects.all(),
 #               fields=['username', 'email']
 #           )
 #       ]
    
class ContenidoSerializer(serializers.ModelSerializer):
    class Meta:
        model=Contenido
        fields = '__all__'

class TicketSerializer(serializers.ModelSerializer):
    contenido = ContenidoSerializer(many=True)
    class Meta:
        model = Ticket
        fields = '__all__'

class TareaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tarea
        fields = '__all__'



from rest_framework import serializers
from .models import Formulario, Campo, Opcion

class OpcionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Opcion
        fields = ['id', 'nombre', 'valor']



class CampoSerializer(serializers.ModelSerializer):
    #tipo = serializers.CharField(source='get_tipo_display', read_only=True)
    opciones = OpcionSerializer(many = True)
    class Meta:
        model = Campo
        fields = ['id', 'nombre', 'tipo', 'opciones'] 

class FormularioSerializer(serializers.ModelSerializer):
    campos = CampoSerializer(many=True, read_only=True)

    class Meta:
        model = Formulario
        fields = ['id', 'titulo', 'descripcion', 'campos', 'categoria', 'oculto']
