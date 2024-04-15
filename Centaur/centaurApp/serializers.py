from rest_framework import serializers
from centaurApp.models import Agente, Ticket, Usuario
from rest_framework.authtoken.models import Token
from rest_framework.validators import UniqueTogetherValidator
from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer

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
        extra_kwargs = {
            'fecha': {'read_only': True, 'required': False},
            # 'fecha': {'read_only': True},
        } 