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

mkdir -p ~/Dev/$main_project_folder
cd ~/Dev/$main_project_folder

python -m venv venv
source venv/bin/activate

echo "By default pip will be upgraded"
echo "and following packages will be installed:"
default_packages="django flake8 black python-dotenv"
echo $default_packages
read -p "Add another packages separated by space: " added_packages

arr_packages=($default_packages $added_packages)

for package in ${arr_packages[@]}; do
    echo $package >> requirements.txt;
done

pip install --upgrade pip
pip install -r requirements.txt

django-admin startproject $project_name
cd $project_name
python manage.py startapp $app_name

# Modifying settings.py
cd $project_name

## regesters first app
app_name_title=$(echo ${app_name^}Config)
register_app="'$app_name.apps.$app_name_title',"
sed -i "/INSTALLED_APPS/a $register_app" settings.py

## looks for first "from" and deletes everything above
sed -i '/from/,$!d' settings.py
sed -i '/from django.contrib import admin/,$!d' urls.py


## insert "load_dotenv()" on 3rd line
sed -i '1 i from dotenv import load_dotenv' settings.py
sed -i '4 a load_dotenv()' settings.py

## insert "import os" and "Enter" before the 1st line
sed -i '1 i import os\n' settings.py

## place original SECRET_KEY into .env file (with removed spaces btw :wink )
secret_key=$(grep "SECRET_KEY" settings.py) 
echo $secret_key | sed 's/\s*//g' >> ../../.env
not_secret_key="SECRET_KEY = os.getenv('SECRET_KEY')"

## substitute SECRET_KEY with .env value
sed -i "s/SECRET_KEY.*/$not_secret_key/g" settings.py

## adding STATIC and MEDIA to settings.py
static_dirs="STATICFILES_DIRS = ['static/']"
media_url="MEDIA_URL = 'media/'"
media_root="MEDIA_ROOT = os.path.join(BASE_DIR, 'media')"
## have to do them in reverse order, so that they stack over one another
sed -i "/STATIC_URL/a $media_root" settings.py
sed -i "/STATIC_URL/a $media_url" settings.py
sed -i "/STATIC_URL/a $static_dirs\n" settings.py

## clean all comments
sed -i "s/#.*//g" settings.py

## clean up settings.py in installed apps
black settings.py

cd ..
mkdir media static
cd $app_name
mkdir templates
touch urls.py
rm tests.py # comment this line, if tests needed in your project
cd ..
python manage.py makemigrations && python manage.py migrate
echo "Don't forget to 'python manage.py createsuperuser'"
python manage.py runserver
