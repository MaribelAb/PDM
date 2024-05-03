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
    opciones = OpcionSerializer(many=True)

    class Meta:
        model = DropdownField
        fields = ['id', 'opciones']

class CampoSerializer(serializers.ModelSerializer):
    tipo = serializers.CharField(source='get_tipo_display', read_only=True)

    class Meta:
        model = Campo
        fields = ['id', 'nombre', 'tipo']

class FormularioSerializer(serializers.ModelSerializer):
    campos = CampoSerializer(many=True, read_only=True)

    class Meta:
        model = Formulario
        fields = ['id', 'titulo', 'descripcion', 'campos']

    def create(self, validated_data):
        campos_data = validated_data.pop('campos', [])
        formulario = Formulario.objects.create(**validated_data)
        for campo_data in campos_data:
            tipo = campo_data.pop('tipo')
            if tipo == 'Texto':
                campo = TextField.objects.create(**campo_data)
            elif tipo == 'Desplegable':
                opciones_data = campo_data.pop('opciones', [])
                campo = DropdownField.objects.create(**campo_data)
                for opcion_data in opciones_data:
                    Opcion.objects.create(campo=campo, **opcion_data)
            formulario.campos.add(campo)
        return formulario
