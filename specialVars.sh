#!/bin/bash

echo "All varibales passed to the script: $@" # All variables passed to the script
echo "All varibales passed to the script: $*" # All variables passed to the script as a single string
echo "Total number of arguments passed: $#" # Total number of arguments passed to the script
echo "Script Name: $0" # Name of the script which is executing

ech0 "Current Directory: $PWD" # Current Directory
echo "Home Directory: $HOME" # Home Directory
echo "User Name: $USER" # User Name
echo "Home Directory of the user: $Home" # Home Directory of the user
echp "PID of the current script: $$" # PID of the current script # Course name is :"$COURSE