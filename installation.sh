#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privileges."
    exit 1
fi 

#dnf list installed mysql
#if [ $? -ne 0 ]; then
#    dnf install mysql -y
#    VALIDATE $? "mysql"
#else
#    echo -e "Mysql already installed.... $G Skipping the installation $N"
#fi

CHECK_ALREADY_INSTALLED(){
    if [ $1 -ne 0 ]; then
        echo -e "$Y $2 is not installed on the system. Proceeding with installation... $N"
        dnf install nginx -y
        VALIDATE $? "nginx"
    else 
        echo -e "$2 already installed.... $G Skipping the installation $N"
    fi
}

VALIDATE(){
    if [$1 -ne 0 ]; then
        echo "ERROR:: Installinig $2 Failed"
        exit 1
    else 
        echo -e " $2  is Installed Successfully"
    fi
}
CHECK_ALREADY_INSTALLED $? "nginx"