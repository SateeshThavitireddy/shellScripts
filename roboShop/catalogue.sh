#!/bin/bash

USERID=$(id -u)

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
CATALOGUE_HOST=catalogue.cloncurry.fun

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

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disable Nodejs module"

dnf module enable nodejs:20 -y
VALIDATE $? "Enable Nodejs 20 module"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Install Nodejs"

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
else
    echo -e "$Y roboshop user already exists $N" &>>$LOG_FILE
fi
VALIDATE $? "Add roboshop user"

mkdir -p   /app &>>$LOG_FILE
VALIDATE $? "Create application directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "Download catalogue application code"

cd /app 
VALIDATE $? "Change directory to /app"

unzip /tmp/catalogue.zip
VALIDATE $? "Extract catalogue application code"

cd /app 
VALIDATE $? "Change directory to /app"

npm install 
VALIDATE $? "Installed nodejs dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copy catalogue systemd service file"   

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "Reload systemd"


systemctl enable catalogue 
VALIDATE $? "Enable catalogue service"
systemctl start catalogue
VALIDATE $? "Start catalogue service"

cp $SCRIPT_DIR/mongodb.rep dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Install Mongodb client"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Install MongoDB client"

mongosh --host MONGODB_HOST </app/db/master-data.js

INDEX=$(mongosh mongodb.daws86s.fun --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Load catalogue products"
else
    echo -e "Catalogue products already loaded ... $Y SKIPPING $N"
fi

systemctl restart catalogue
VALIDATE $? "Restarted catalogue"