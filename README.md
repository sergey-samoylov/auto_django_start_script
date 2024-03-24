# AUTO DJANGO >>> django.sh script

## Starting up a Django project never has been easier

- **django.sh** checks for needed variables
- asks for the project folder/directory name

![script checks for two variables](img/1.png)

- creates needed folders

![Give name to your project directory](img/2.png)

- does all the rest

![it even edits settings.py file and registers the first app](img/3.png)

- creates crisp requirements.txt (only used packages, without dependecies, as they will be autoinstalled anyway 😉)

![Clean requirements.txt](img/4.png)

### What it does:

- **django.sh** installs virtual environment
- **django.sh** installs and upgrades pip
- **django.sh** installs flake8 and black
- **django.sh** creates nice and clean requirements.txt (added in v0.2 of the script)
- **django.sh** edits settings.py (deletes comments, regirsters your first app)
- **django.sh** starts developer web-server of you Django project

## Enjoy!

- feel free to modify this script and tailor to your needs.
- consider giving it a star, if you like it 🙂
