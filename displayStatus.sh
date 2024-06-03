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
lastchecktime=$(cat "/home/Core/lastchecktime.txt" 2>/dev/null || echo 0)
latestsubmission=''
currenttime=$(date +%s)

for mentee in "/home/Core/mentees"/*; do
    menteeName=$(basename "$mentee")
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
        if [ "$status" == "y" ]; then 
           tasksubmitted["index"]=$((tasksubmitted["index"]+1))
           if [ $(stat -c %Y "/home/Core/mentees/$menteeName/$domain/$task") -gt "lastchecktime" ]; then 
               latestsubmission+="$menteeName submited $task in $domain\n"
            fi
        fi 
    done <"/home/Core/mentees/$menteeName/task_submitted.txt"
done 
echo "Percentage of total submissions"
for filter in "${!taskcounter[@]}"; do 
    domain=$(echo "filter" | cut -d '' -f1)
    task=$(echo "filter" |cut -d '' -f2)
    total=$(taskcounter["filter"])
    submitted=$(tasksubmited["filter"])
    percentage=$((100*submitted/total))
    echo " $domain $task : $perecentage submitted"
done 
echo -e "\nRecent Submissions"
echo -e "$latestsubmission"
    


