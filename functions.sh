#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo "You have to run this scipt as root user"
    exit 1
fi 

VALIDATE(){
    if [  $1 -ne 0 ]; then
        echo "ERROR: $2 Installation failed"
        exit 1
    else
        echo "Installing $2 is successful"
    fi
}

dnf install mysql -y
VALIDATE $? "MYSQL"

dnf install nginx -y
VALIDATE $? "NGINX"