#!/bin/bash
set -e

trap 'echo "There is an error in line $LINENO, Command is: $BASH_COMMAND"' ERR

echo "Hello, this is set.sh script!"
echo "Before Error"

ccaffss
echo "After Error"