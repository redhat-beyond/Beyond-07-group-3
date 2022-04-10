#!/bin/bash -ex

# replace .bashrc file from vagrant directory to ~ directory
cp /vagrant/.bashrc .bashrc

# preventing error "$'\r': command not found"
sed -i 's/\r$//' .bashrc

# Install Pipenv, the -n option makes sudo fail instead of asking for a
# password if we dont have sufficient privileges to run it
sudo -n dnf install -y pipenv

cd /vagrant
# Install dependencies with Pipenv
pipenv sync --dev

# run database migrations
pipenv run python manage.py migrate

# run our app on localhost port
setsid pipenv run python manage.py runserver 0.0.0.0:8000 > runserver.log 2>&1 &
