#!/bin/bash

START_DATE=$(date +%s)

sleep 10 &

END_DATE=$(date +%s)

TOTAL_TIME =$((END_DATE - START_DATE))

echo "Total time taken: $TOTAL_TIME seconds"