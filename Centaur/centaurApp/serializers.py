from rest_framework import serializers
from centaurApp.models import Agente, Ticket, Usuario
from rest_framework.authtoken.models import Token
from rest_framework.validators import UniqueTogetherValidator
from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from .models import Formulario, Campo, Opcion

#class NewRegisterSerializer(RegisterSerializer):
#    nombre = serializers.CharField()
#    apellido = serializers.CharField()

#    def custom_signup(self, request, user):
#        user = request.data['nombre']
#        user = request.data['apellido']
#        user.save()

#class NewLoginSerializer(LoginSerializer):
#    pass


class AgentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Agente
        fields = '__all__'


class UserSerializer(serializers.ModelSerializer):

    def create(self, validated_data):
        user = Usuario.objects.create_user(**validated_data)
        return user

    class Meta:
        model = Usuario
        fields = (
            'username',
            'nombre',
            'apellido',
            'email',
            'password',
        )
        validators = [
            UniqueTogetherValidator(
                queryset=Usuario.objects.all(),
                fields=['username', 'email']
            )
        ]
    

class TicketSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ticket
        fields = '__all__'



from rest_framework import serializers
from .models import Formulario, Campo, TextField, DropdownField, Opcion

class OpcionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Opcion
        fields = ['id', 'nombre', 'valor']

class TextFieldSerializer(serializers.ModelSerializer):
    class Meta:
        model = TextField
        fields = ['id', 'texto']

class DropdownFieldSerializer(serializers.ModelSerializer):
    # No necesitas un serializador separado para DropdownField,
    # Puedes incluir directamente las opciones dentro de este serializador
    opciones = OpcionSerializer(many=True)

    class Meta:
        model = DropdownField
        fields = ['id', 'nombre', 'tipo', 'opciones']  # Ajusta según tu modelo Campo

class CampoSerializer(serializers.ModelSerializer):
    tipo = serializers.CharField(source='get_tipo_display', read_only=True)
    # Incluye el serializador de DropdownField para los campos de tipo desplegable
    dropdown_field = DropdownFieldSerializer()

    class Meta:
        model = Campo
        fields = ['id', 'nombre', 'tipo', 'dropdown_field']  # Ajusta según tu modelo Campo

class FormularioSerializer(serializers.ModelSerializer):
    campos = CampoSerializer(many=True, read_only=True)

    class Meta:
        model = Formulario
        fields = ['id', 'titulo', 'descripcion', 'campos']
