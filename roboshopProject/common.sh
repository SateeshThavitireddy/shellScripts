#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
M="\e[35m"
C="\e[36m"
W="\e[37m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$(echo $ | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
START_TIME=$(date +%s)
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.cloncurry.fun
MYSQL_HOST=mysql.cloncuury.fun

mkdir -p $LOGS_FOLDER
echo "Script Started Execution at : $(date)" &>>$LOG_FILE

check_root(){
    if [ $USERID -ne 0 ]; then
      echo -e "$R You should execute this script as root user $N" | tee -a $LOG_FILE
      exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then 
        echo -e "$R $2 Failed to install $N" | tee -a $LOG_FILE
        exit 1
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "Disabling Nodejs Module"
    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "Enabling Nodejs 20 Module"
    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "Installing Nodejs"
    npm install &>>$LOG_FILE
    VALIDATE $? "Install Nodejs Dependencies"
}

java_setup(){
    dnf install maven -y &>>$LOG_FILE
    VALIDATE $? "Installing Maven"
    mvn clean package &>>$LOG_FILE
    VALIDATE $? "Packing the application"
    mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
    VALIDATE $? "Renaming the jar file"
}

python_setup(){
    dnf install python3 gcc python3-devel -y &>>$LOG_FILE
    VALIDATE $? "Insatlling Python3"
    pip3 install -r requirements.txt &>>$LOG_FILE
    VALIDATE $? "Installing Python Dependencies"
}

app_setup(){
    id roboshop &>>$LOG_FILE
    if [ $? -ne 0 ]; then
       useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
       VALIDATE $? "Creating system user"
    else
        echo -e "User already exist ... $Y SKIPPING $N"
    fi

    mkdir -p /app &>>$LOG_FILE
    VALIDATE $? "Creating Application Directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VALIDATE $? "Downloading $app_name application"

    cd /app 
    VALIDATE $? "Changing to app directory"

    rm -rf /app/*
    VALIDATE $? "Removing existing code"

    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "unzip $app_name"
}


systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copy systemctl service"

    systemctl daemon-reload
    systemctl enable $app_name &>>$LOG_FILE
    VALIDATE $? "Enable $app_name"
}

app_start(){
    systemctl restart $app_name
    VALIDATE $? "Restarted $app_name"
}

app_start_enable(){
    systemctl enable $app_name  &>>$LOG_FILE
    VALIDATE $? "Enabling $app_name"
    systemctl start "Starting $app_name"  &>>$LOG_FILE
    VALIDATE $? "Starting $app_name" 
}
print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "Script executed in: $Y $TOTAL_TIME Seconds $N"
}