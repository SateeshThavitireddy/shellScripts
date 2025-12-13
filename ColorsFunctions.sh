#!/bin/bash

USERID = $(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo -e "$R you cannot run this script as non root user $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "INSTALLATION FAILED FOR $2 $N"
        exit 1
    else 
        echo -e "$G INSTALLATION SUCCESSFUL FOR $2 $N"
    fi
}

CHECK_ALREADY_INSTALLED(){
    if [ $1 -eq 0 ]; then
        echo "$G preparing to install $2 $N"
        dnf install $2 -y
        VALIDATE $? $2
    else
      echo -e "$Y $2 already installed on this server $N"
    fi
}

CHECK_ALREADY_INSTALLED $? "MYSQL"
CHECK_ALREADY_INSTALLED $? "python3"
