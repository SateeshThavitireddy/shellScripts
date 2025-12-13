#!/bin/bash

USERID=$(id)

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script as root user"
    exit 1
fi

dnf install mysql -y

if [ $? -ne 0 ]; then
    echo "ERROR:: Installing MYSQL is failure"
    exit 1
else
    echo "INstalling MYSQL is SUCCESS"
fi