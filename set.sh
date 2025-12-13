#!/bin/bash

set -e

trap 'echo "There is an error in $LINENUMBER, Command is: $BASH_COMMAND"'ERR

echo "Hello, this is set.sh script!"
echo "Before Error"

ccaffss; dnf
echo "After Error"