echo -n "Enter users file: "
read file
while read user || [[ -n "$user" ]]
do 
        docker create -it --name $user infra:v1 /bin/bash
        done < "$file"
