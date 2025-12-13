#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"



LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "$R you cannnot run this script without root user $N" | tee -a $LOG_FILE
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "INSTALLATION $2 ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "INSTALLATION $2 ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi 
}

CHECK_ALREADY_INSTALLED(){
    dnf list installed $1 &>>$LOG_FILE
    status=$?
    if [ $status -ne 0 ]; then
        echo -e "$G preparing to install the $2 $N" | tee -a $LOG_FILE
        dnf install $2 -y &>>$LOG_FILE
        VALIDATE $? $2
    else
      echo -e "$Y $2 is already installed on this server $N" | tee -a $LOG_FILE
    fi
}

CHECK_ALREADY_INSTALLED "mysql" &>>$LOG_FILE