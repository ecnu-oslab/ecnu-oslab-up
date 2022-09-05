#!/bin/bash

n=$(( RANDOM % 100 ))

if [[ n -eq 42 ]]; then
   echo "Something went wrong"
   echo "Error code 42: answer unknown" >&2
   exit 1
fi

echo "All good"