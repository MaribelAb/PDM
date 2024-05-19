# Generated by Django 4.2.11 on 2024-05-17 10:38

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('centaurApp', '0008_ticket_fecha_creacion'),
    ]

    operations = [
        migrations.AddField(
            model_name='formulario',
            name='categoria',
            field=models.CharField(blank=True, max_length=100),
        ),
        migrations.AddField(
            model_name='formulario',
            name='oculto',
            field=models.BooleanField(default=True),
        ),
    ]