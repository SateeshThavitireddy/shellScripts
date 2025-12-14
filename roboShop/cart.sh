#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[om"

if [ $USERID -ne 0 ]; then
    echo -e "$R you cannot run this script wihtout root privileges $N"
    exit 1
fi

LOG_FOLDER="/var/log/roboshop"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
MONGODB_HOST="mongodb.cloncurry.fun"

mkdir -p $LOG_FOLDER
echo "Script started execution at $(date +%s)" | tee -a $LOG_FILE

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$R $2 Failed $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$G $2 Success $N" | tee -a $LOG_FILE
    fi
}

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disable Nodejs module"
dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enabling Nodejs 20 module"
dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installing Nodejs"

id roboshop &>>$LOG_FILE
if  [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
    VALIDATE $? "Creating roboshop user"
else
    echo -e "User already exist ... Skipping user creation"  &>>$LOG_FILE
fi

mkdir -p /app &>>$LOG_FILE
VALIDATE $? "Creating application directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip
VALIDATE $? "Downloading cart application code"

cd /app 
VALIDATE $? "Changing directory to /app"

rm -rf /app/*
VALIDATE$? "Deleting the old application code  "

unzip /tmp/cart.zip
VALIDATE $? "Extracting cart application code"


cd /app 
VALIDATE $? "Changing directory to /app"

npm install 


systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "Reloading systemctl daemon"

systemctl enable cart 
systemctl start cart