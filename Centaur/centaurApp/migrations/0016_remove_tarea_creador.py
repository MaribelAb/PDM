# Generated by Django 4.2.11 on 2024-05-20 10:27

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('centaurApp', '0015_alter_tarea_creador'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='tarea',
            name='creador',
        ),
    ]