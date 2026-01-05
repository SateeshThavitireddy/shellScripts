#!/bin/bash

source ./common.sh
check_root

cp ./mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding MongoDb Repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDb"

app_start_enable mongodb

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing Remote Connections in Mongodb"

app_start mongodb
print_total_time