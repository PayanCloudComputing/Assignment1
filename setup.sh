#!/bin/bash

APP=$1

echo "Installing Git"
brew install git
echo "Installing NodeJs..."
brew update
brew install node
brew link --override node
echo "Installing AWS CLI..."
sudo easy_install pip
pip install awscli --upgrade --user
echo "Installing Yeoman..."
sudo npm install -g yo
echo "Installing Grunt..."
sudo npm install grunt-cli -g
echo "Installation completed."
echo "Creating Angular project..."
yo angular $APP
echo "Setup completed."
echo "Psst! Run grunt serve --force"