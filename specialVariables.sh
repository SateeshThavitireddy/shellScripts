#!/bin/bash

echo "All varibales passed to the script : $@"
echo "All varibales passed to script :$*"
echo "Script name : $0"
echo "Current Dirtectory : $PWD"
echo "Who is running this:$USER"
echo "Home directory of user: $HOME"
echo "PID of this script: $$"

slepp 50 &

echon "PID of the last command in backrgopund is: $!