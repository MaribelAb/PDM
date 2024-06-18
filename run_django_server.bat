@echo off


REM Activate the virtual environment
call myenv\Scripts\activate

REM Navigate to the Centaur directory
cd Centaur

REM Run Django commands
python manage.py makemigrations
python manage.py migrate
python manage.py runserver localhost:8000

