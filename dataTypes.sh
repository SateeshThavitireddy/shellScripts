#!/bin/bash

NUMBER1=100
NUMBER2=200

SUM=$(($NUMBER1 + $NUMBER2))

echo "Sum is ${SUM}"

LEADERS=("MODI","PUTIN","TRUDO","TRUMP")

echo "ALL leaders: ${LEADERS[@]}"
echo "First leader: ${LEADERS[0]}"
echo "FIRST Leader: ${LEADERS[9]}"