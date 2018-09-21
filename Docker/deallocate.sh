#!/bin/bash

echo -n "Enter users file: "
read file

while read user || [[ -n "$user" ]]
    do
      docker stop $user
      docker rm $user
    done < $file
