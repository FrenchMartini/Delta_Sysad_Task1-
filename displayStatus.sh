#!/bin/bash 
user=$(whoami)
#First checking if user is Core 
if [[ "$user" == "Core" ]]; then 
    echo "User verified proceeding to show status !"
else 
    echo "Permission not granted"
fi 
#Declaring arrays to keep count of domain and task submissions"
declare -a taskcounter
declare -a taskcompleted
# This makes the lastchecktime set to 0 at start and later on gets changed if any new  , any errors will be sent to /dev/null
lastchecktime=$(cat "/home/Core/lastchecktime.txt" 2>/dev/null || echo 0)
latestsubmission=''
#getting current time and updating lastchecktime.txt 
currenttime=$(date +%s)
echo "currenttime" > "/home/Core/lastchecktime.txt"

for mentee in "/home/Core/mentees"/*; do
    menteeName=$(basename "$mentee")
# getting submission details of mentee from home dir 
    while IFS= read -r line; do 
        line=$(echo "$line" | xargs)
        if  [[ "${line: -1}" == ":" ]]; then 
            domain="${line%:}"
            continue 
        fi 
        IFS=":" read -r task status <<< "$line"
        task=$(echo "$task" | xargs) 
        status=$(echo "$status" | xargs)
        if [ -z "$domain" ] || [ -z "$task" ] || [ -z "$status" ]; then
        continue
        fi
#increasing the submitted task counter if status is y and using stat to display date of file and then checking if there is lates submission
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
#printing total submission filtering domain and task wise 
echo "Percentage of total submissions"
for filter in "${!taskcounter[@]}"; do 
    domain=$(echo "filter" | cut -d '' -f1)
    task=$(echo "filter" |cut -d '' -f2)
    total=$(taskcounter["filter"])
    submitted=$(tasksubmited["filter"])
    percentage=$((100*submitted/total))
    echo " $domain $task : $perecentage submitted"
done 
#printing recent submissions 
echo -e "\nRecent Submissions"
echo -e "$latestsubmission"
    


