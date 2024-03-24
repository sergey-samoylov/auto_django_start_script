#!/usr/bin/env bash
# CREATES A DJANGO PROJECT WITH FIRST APP OF YOUR CHOICE
# author: Sergey Samoylov
# name of the script: django.sh

if [ "$#" -lt 2 ] # if args less than two
    then
        echo "Two names needed"
        echo "Example: $0 project_name app_name"
        exit 1 # exits with mistake code 1
fi

read -p "Enter directory name for your Django project: " main_project_folder
project_name=$1
app_name=$2

mkdir ~/Dev/$main_project_folder
cd ~/Dev/$main_project_folder

python -m venv venv
source venv/bin/activate

echo "By default pip will be upgraded"
echo "and following packages will be installed:"
default_packages="django flake8 black"
echo $default_packages
read -p "Add another packages separated by space: " added_packages
pip install --upgrade pip
pip install $default_packages $added_packages
pip freeze > requirements.txt

django-admin startproject $project_name
cd $project_name
python manage.py startapp $app_name

# Modifying to settings.py
cd $project_name
app_name_caps=$(echo ${app_name^}Config)
register_app="'$app_name.apps.$app_name_caps',"
sed -i "/INSTALLED_APPS/a $register_app" settings.py
sed -i '/from/,$!d' settings.py
black settings.py

cd ..
python manage.py makemigrations && python manage.py migrate
python manage.py runserver
