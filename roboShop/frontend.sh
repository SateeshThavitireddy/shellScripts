#!/bin/bash

$USERID=($id -u)
R="\e[31m"
G="\e[31m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo -e "$R you can't run this script without root privileges $N"
    exit 1
fi  

LOG_FOLDER="/var/log/roboshop"
SCRIPT_NAME=$(echo $0 | cut -d "." -f )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD                             

mkdir -p $LOG_FOLDER
echo "Script started execution at $(date)" &>>$LOG_FILE

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$R $2 Failed $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$G $2 Succeeded $N" | tee -a $LOG_FILE
    fi
}

dnf module disable nginx -y
VALIDATE $? "Disable Nginx module"
dnf module enable nginx:1.24 -y
VALIDATE $? "Enable Nginx 1.24 module"
dnf install nginx -y
VALIDATE $? "Install Nginx"

systemctl enable nginx 
VALIDATE $? "Enable Nginx"
systemctl start nginx 
VALIDATE $? "Start Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Clean Nginx default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "Download Frontend content"

rm -rf /usr/share/nginx/html/* 
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "Downloading frontend"

rm -rf /etc/nginx/nginx.conf
cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copying nginx.conf"

systemctl restart nginx 
VALIDATE $? "Restarting Nginx"
