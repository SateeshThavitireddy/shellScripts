#!/bin/bash

source ./common.sh
check_root

dnf install mysql-server -y
VALIDATE $? "Installing MySQL Server"   
app_start_enable mysql
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "Setting root password to MySQL Server"
print_total_time