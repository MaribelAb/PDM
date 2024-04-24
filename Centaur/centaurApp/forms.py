from django import forms

from .models import Ticket

class TemplateForm(forms.ModelForm):
    class Meta:
        model = Ticket
        fields = (
            'titulo',
            'descripcion',
            'solicitante'
        )