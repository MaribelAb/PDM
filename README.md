# Centaur: Software de Centro de Atención al Usuario

## Descripción del Proyecto

Este Trabajo de Fin de Grado (TFG) trata sobre el desarrollo de una aplicación web de Centro de Atención al Usuario llamada Centaur.
La función de esta aplicación es la de funcionar como punto de conexión, tanto dentro de una empresa u organización conectando empleados entre sí y asignándoles responsabilidades compartidas, como fuera conectando a la empresa con personas externas, ya sean ciudadanos, colaboradores, empresas u organizaciones.
Además, Centaur ofrecerá una herramienta de consulta a los líderes de la organización u empresa para poder ver estadísticas y datos de interés del CAU, y estará adaptada para cualquier tipo de dispositivo (móvil, tablet u ordenador) sin importar en qué rol se utilice.
El desarrollo de esta aplicación se ha realizado utilizando la metodología de desarrollo ágil Scrum, y aplicando técnicas de diseño centradas en el usuario como el design thinking o el diseño centrado en el usuario. Además, se ha prestado especial atención a la accesibilidad y la usabilidad de la aplicación, realizando pruebas con usuarios reales para evaluar ambos puntos.

## Funcionalidades

- **Registro de Usuarios**: Permite a los usuarios crear una cuenta para acceder al sistema.
- **Gestión de Consultas**: Los usuarios pueden enviar consultas que serán gestionadas por el equipo de atención al cliente.
- **Sistema de Tickets**: Cada consulta se convierte en un ticket, facilitando el seguimiento y la resolución de problemas.
- El manejo de roles en la aplicación: administrador, agente y cliente.
- Creación de un diseño funcional adaptado a móvil para cada rol.
- **Nivel de accesibilidad**: A
- **Usabilidad**: Calificación SUS de 76,7 (B), Aceptable


## Tecnologías Utilizadas

- **Frontend**: Flutter + Dart
- **Backend**: Django Rest Api
- **Base de Datos**: SQLite
- **Autenticación**: JWT (JSON Web Tokens)

## Instalación
1. Instalación de django:
Para instalar Django 3.2.10, se deben de tener previamente instalada la herramienta pip, e instalado python en la máquina host.

**Creación del entorno virtual**
Antes de instalar Django se debe crear un entorno virtual (también llamado un virtualenv). Virtualenv aísla la configuración de Python/Django para cada proyecto, de tal forma que cualquier cambio que se haga en un sitio web no afectará a ningún otro que se esté desarrollando.
Para ello, se debe uno situar en el directorio base del proyecto y ejecutar la siguiente orden en un terminal:

python -m venv myvenv

Donde myvenv es el nombre del virtualenv. El comando anterior creará un directorio llamado myvenv (o cualquier nombre que se haya elegido) que contiene el entorno virtual.
El entorno virtual se inicia con la siguiente órden:

myvenv\Scripts\activate

Se sabrá que se tiene virtualenv iniciado cuando se vea que la línea de comando en el consola tiene el prefijo (myvenv).

**Instando Django**
La instalación de Django se realizará utilizando la herramienta pip. Para ello, primero nos aseguramos de que tenemos la última versión de esta herramienta instalada.

(myvenv) ~$ python -m pip install --upgrade pip

Tras esto, se debe crear un archivo requirements.txt dentro del directorio seleccionado para el proyecto, utilizando cualquier editor de código. Dentro de este fichero se debe de tener la siguiente línea:

Django~=3.2.10

Tras esto, se debe ejecutar pip install -r requirements.txt para instalar Django.

Ahora, ejecuta pip install -r requirements.txt para instalar Django. Debería de aparecer la siguiente salida:

Collecting Django~=3.2.10 (from -r requirements.txt (line 1))
  Downloading Django-3.2.10-py3-none-any.whl (7.1MB)
Installing collected packages: Django
Successfully installed Django-3.2.10

Esto indica que Django ha sido instalado correctamente. Para comprobarlo, ejecuta la orden python -m django --version, cuya respuesta debería de ser 3.2.10, la versión de Django instalada.

2. Instalando Flutter
El proceso de instalación de flutter se explicará para realizarlo en la herramienta Visual Studio Code.

Una vez abierto Visual Studio Code, se debe buscar la sección de extensiones y buscar la extensión de Flutter, y la extensión de Dart. Una vez instaladas, el siguiente paso es descargarse el sdk de flutter, el cuál se puede obtener en la página oficial de flutter (https://docs.flutter.dev/get-started/install/windows).
Para este proyecto, se ha utilizado Flutter 3.16.3, con lo cual se ha descargado su correspondiente SDK.

Una vez que descargamos el archivo lo movemos a una carpeta dentro de nuestros discos y ahí lo descomprimimos.

En Visual Studio Code, nos vamos a Command Palette y escribimos flutter, seleccionando crear new project. Para crear el proyecto, nos pedirá la ruta del SDK de flutter que se ha descargado previamente. Una vez hecho esto, ya se podrá utilizar Flutter.

3. Instalando Visual Studio Code

La instalación en Windows 10 es muy sencilla: simplemente hay que dirigirse a la página oficial de visual studio (https://code.visualstudio.com/), descargar el ejecutable, e instalarlo.

4. Clona el repositorio:
git clone https://github.com/MaribelAb/TFG

5. Ejecuta los dos scripts: run_django_server y run_flutter_project
   
