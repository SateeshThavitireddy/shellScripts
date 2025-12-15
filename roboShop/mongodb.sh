#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

if  [ $USERID -ne 0 ]; then
    echo -e "${R}You should be a root user to run this script${N}"
    exit 1
fi  

