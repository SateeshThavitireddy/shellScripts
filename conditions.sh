#!/bin/bash

NUMBER=$1

# LESS THAN (-lt)
echo "=== LESS THAN (-lt) ==="
if [ $NUMBER -lt 10 ]; then
    echo "The number $NUMBER is less than 10"
else 
    echo "The number $NUMBER is NOT less than 10"
fi

# GREATER THAN (-gt)
echo ""
echo "=== GREATER THAN (-gt) ==="
if [ $NUMBER -gt 10 ]; then
    echo "The number $NUMBER is greater than 10"
else
    echo "The number $NUMBER is NOT greater than 10"
fi

# LESS THAN OR EQUAL (-le)
echo ""
echo "=== LESS THAN OR EQUAL (-le) ==="
if [ $NUMBER -le 10 ]; then
    echo "The number $NUMBER is less than or equal to 10"
else
    echo "The number $NUMBER is greater than 10"
fi

# GREATER THAN OR EQUAL (-ge)
echo ""
echo "=== GREATER THAN OR EQUAL (-ge) ==="
if [ $NUMBER -ge 10 ]; then
    echo "The number $NUMBER is greater than or equal to 10"
else
    echo "The number $NUMBER is less than 10"
fi

# EQUAL (-eq)
echo ""
echo "=== EQUAL (-eq) ==="
if [ $NUMBER -eq 10 ]; then
    echo "The number $NUMBER is equal to 10"
else
    echo "The number $NUMBER is NOT equal to 10"
fi

# NOT EQUAL (-ne)
echo ""
echo "=== NOT EQUAL (-ne) ==="
if [ $NUMBER -ne 10 ]; then
    echo "The number $NUMBER is NOT equal to 10"
else
    echo "The number $NUMBER is equal to 10"
fi