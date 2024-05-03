from django.contrib import admin

from centaurApp.models import Agente, Campo, DropdownField, Formulario, Opcion, Tarea, TextField, Ticket, Usuario

# Register your models here.
class UsuarioAdmin(admin.ModelAdmin):

    search_fields = ['email']
        #autocomplete_fields = ['department',]

    list_display = ('nombre', 'apellido',)
    def save_model(self, request, obj, form, change):
        if not change:
            obj.set_password(form.cleaned_data['password'])
        super().model_save(request, obj, form, change)
            


admin.site.register(Usuario, UsuarioAdmin)
admin.site.register(Agente)
admin.site.register(Tarea)
admin.site.register(Ticket)
admin.site.register(Formulario)
admin.site.register(Opcion)
admin.site.register(Campo)
admin.site.register(DropdownField)
admin.site.register(TextField)

