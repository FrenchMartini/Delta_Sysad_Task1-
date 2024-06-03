#!/bin/bash 
user=$(whoami)
#First checking if user is Core 
if [[ $user == "Core" ]]; then 
    echo "User verified proceeding to show status !"
else 
    echo "Permission not granted"
fi 

declare -a taskcounter
declare -a taskcompleted

for mentee in "/home/Core/mentees"/*; do
    while IFS= read -r line; do 
        line=$(echo "$line" | xargs)
        if  [[ "${line: -1}" == ":"]]; then 
            domain="${line%:}"
            continue 
        fi 
        IFS=":" read -r task status <<< "$line"
        task=$(echo "$task" | xargs) 
        status=$(echo "$status" | xargs)
        if [ -z "$domain" ] || [ -z "$task" ] || [ -z "$status" ]; then
        continue
        fi 
        index="$domain $task"
        taskcounter["index"]=$((taskcounter["index"]+1))
        if [ "$status" == "
        
        
    done <"/home/Core/mentees/$mentee"


