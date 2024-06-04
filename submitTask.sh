#!/bin/bash
user=$(whoami)
############################MenteeScript#######################################
awk '{print $1}' "/home/Desktop/Delta_Sysad/menteeDetails.txt" | tail -n +2 | while IFS= read -r name; do
    if [[ "$user" == "$name" ]]; then 
        echo " Welcome mentee"
    else 
        echo "Permission not granted"
    fi 
done 

#Populating the details into taks_Submitted while also creating directories based on the input of mentee 
for domain in sysad web app; do
    echo "$domain:"
    for task in Task1 Task2 Task3; do
        echo -n "Is $task completed? (y/n): "
        read -r status 
        while [[ "$status" != "y" && "$status" != "n" ]]; do
            echo "Invalid input,  Please enter 'y' for yes or 'n' for no."
            echo -n "Is $task completed? (y/n): "
            read -r status
        done
        echo "    $task: $status"
        if [[ $status == 'y' ]]; then 
            mkdir -p "/home/Core/mentees/$user/$domain/$task" 
            echo "Task directory created successfully"
        fi 
    done 
done >> "/home/Core/mentees/$user/task_submitted.txt"
###############################MentorScipt#######################################

#Checking if user is a mentor by finding if their dir exists 
while IFS=' ' read -r mentorName mentorDomain _; do
    if [[ $user == "mentorName" ]]; then 
        echo " Welcome mentor "
        Domain=$mentorDomain
    else 
        echo "Permission not granted"
    fi 
done < "/home/Desktop/Delta_Sysad/mentorDetails.txt"
# First reading mentee names from each mentors allocated mentees
# and then updating task_completed.txt and creating a symbolic link from mentors dir to menteees dir 
while read -r rollnumber menteename; do 
    for task in Task1 Task2 Task3; do       
        if [ -d "/home/Core/mentees/$menteeName/$domain/$task" ]; then
             echo " $Domain $task Y" >> "/home/Core/mentees/$menteename/task_completed.txt"
             ln -s /home/Core/mentors/$Domain/$mentorName/submittedTasks/$task /home/Core/mentees/$menteename/$Domain/$task
        fi 
    done
done < "/home/Core/mentors/$Domain/mentorName/allocatedMentees.txt"








