# Generated by Django 4.2.11 on 2024-05-02 08:46

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('centaurApp', '0002_ticket_solicitante'),
    ]

    operations = [
        migrations.CreateModel(
            name='Campo',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nombre', models.CharField(max_length=100)),
                ('tipo', models.CharField(max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='Formulario',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('titulo', models.CharField(max_length=100)),
                ('descripcion', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='Opcion',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('valor', models.CharField(max_length=100)),
                ('campo', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='centaurApp.campo')),
            ],
        ),
        migrations.DeleteModel(
            name='Form',
        ),
        migrations.AddField(
            model_name='campo',
            name='formulario',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='centaurApp.formulario'),
        ),
    ]
