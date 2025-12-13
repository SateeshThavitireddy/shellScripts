#!/bin/bash

START_DATE=$(date +%s)

sleep 10

END_TIME=$(date +%s)

TOTAL_TIME=$(($END_TIME - $START_DATE))

echo "Script executed in: $TOTAL_TIME seconds"