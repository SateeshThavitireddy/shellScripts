#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0N"

LOGS_FOLDER="var/log/shell-script"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Script Started Execution at $(date +%s)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo -e "$R you cannot run this script as non root user $N" | tee -a $LOG_FILE
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "INSTALLATION FAILED FOR $2 $N" | tee -a $LOG_FILE
        exit 1
    else 
        echo -e "$G INSTALLATION SUCCESSFUL FOR $2 $N" | tee -a $LOG_FILE
    fi  

}

for package in $@
do 
    dnf list installed $package &>>$LOG_FILE
    if [ $? -ne 0 ]; then
        dnf install $package -y &>>$LOG_FILE
        VALIDATE $? $package
    else
        echo -e "$Y $package already installed on this server $N" | tee -a $LOG_FILE
    fi
done