#!/bin/bash 

#Creating account for Core with home directory 
sudo useradd -m -d /home/Core Core >/dev/null
#Creating pasword for testing the script
echo "Core:Core" | sudo chpasswd 
echo "Core user account and home directory created"
#Copying the required scripts in the cores home dir 
sudo cp /home/adithya/Desktop/Delta_Sysad/mentorAllocation.sh /home/Core
sudo cp /home/adithya/Desktop/Delta_Sysad/displayStatus.sh /home/Core


#Creating mentor and mentee directories under /home/Core 
sudo mkdir -p /home/Core/mentors 
sudo mkdir -p /home/Core/mentees 
echo "Mentor and Mentee directories created under /home/Core"
#Reading names from first column and filtering first row of details using awk and tail in menteeDetails.txt 
menteeFile=menteeDetails.txt
awk '{print $1}' "$menteeFile" | tail -n +2 | while IFS= read -r menteeName; do
    sudo useradd -m -d "/home/Core/mentees/$menteeName" "$menteeName"  >/dev/null
    sudo cp /home/adithya/Desktop/Delta_Sysad/domainPref.sh /home/Core/mentees/$menteeName
    sudo cp /home/adithya/Desktop/Delta_Sysad/submitTask.sh /home/Core/mentees/$menteeName
    sudo cp /home/adithya/Desktop/Delta_Sysad/deRegister.sh /home/Core/mentees/$menteeName
done
#Created the accounts and home directories for each mentee using useradd command using a whileloop 
echo "Created accounts and home directories for each mentee"

sudo mkdir -p /home/Core/mentors/web
sudo mkdir -p /home/Core/mentors/app
sudo mkdir -p /home/Core/mentors/sysad 
echo "Created folders Webdev,Appdev,Sysad under mentors folder"

mentorFile=mentorDetails.txt
#using input redirection, also filtering out names and domain using IFS as " " 
#Creating mentor accounts and home directories under their respective domains
#Also creating allocatedMentees.txt and submittedTaks directoires under each mentors home directory 
while IFS=' ' read -r mentorName mentorDomain _; do
    
    echo "Prcoessing mentor $mentorName, Domain:$mentorDomain"

    if [[ $mentorDomain = "sysad" ]]; then 
        sudo useradd -m -d "/home/Core/mentors/sysad/$mentorName" "$mentorName" >/dev/null
        sudo mkdir -p "/home/Core/mentors/sysad/$mentorName"
        sudo touch "/home/Core/mentors/sysad/$mentorName/allocatedMentees.txt"
        sudo mkdir -p "/home/Core/mentors/sysad/$mentorName/submittedTasks"
        for taskNumber in {1..3}; do 
           sudo  mkdir -p "/home/Core/mentors/sysad/$mentorName/submittedTasks/task$taskNumber"
        done
        
    elif [[ $mentorDomain = "web" ]]; then 
        sudo useradd -m -d "/home/Core/mentors/web/$mentorName" "$mentorName" >/dev/null
        sudo mkdir -p "/home/Core/mentors/web/$mentorName"
        sudo touch "/home/Core/mentors/web/$mentorName/allocatedMentees.txt"
        sudo mkdir -p "/home/Core/mentors/web/$mentorName/submittedTasks"
        for taskNumber in {1..3}; do 
            sudo mkdir -p "/home/Core/mentors/web/$mentorName/submittedTasks/task$taskNumber"
        done
       
    elif [[ $mentorDomain = "app" ]]; then
        sudo useradd -m -d "/home/Core/mentors/app/$mentorName" "$mentorName" >/dev/null
        sudo mkdir -p "/home/Core/mentors/app/$mentorName"
        sudo touch "/home/Core/mentors/app/$mentorName/allocatedMentees.txt"
        sudo mkdir -p "/home/Core/mentors/app/$mentorName/submittedTasks"
        for taskNumber in {1..3}; do 
            sudo mkdir -p "/home/Core/mentors/app/$mentorName/submittedTasks/Task$taskNumber"
        done
        
    fi 
done < "$mentorFile"
echo "Created accounts and home directories for mentors in their respective domains"

#Creating the required files for each mentee under their home directory
awk '{print $1}' "$menteeFile" | tail -n +2 | while IFS= read -r menteeName; do
    sudo touch "/home/Core/mentees/$menteeName/domain_pref.txt"
    sudo touch "/home/Core/mentees/$menteeName/task_completed.txt"
    sudo touch "/home/Core/mentees/$menteeName/task_submitted.txt"
done 
echo "Created required files for each mentee in their home directory"

sudo touch  "/home/Core/mentees_domain.txt"

#Setting permissions for core 
sudo chown -R Core:Core /home/Core
sudo chmod 750 /home/Core
sudo chmod 750 /home/Core/mentors
sudo chmod 750 /home/Core/mentees
#Setting permissions for mentor dir
for domain in webdev appdev sysad; do
    sudo chmod 750 "/home/Core/mentors/$domain"
done
#setting permission for each mentor 
while IFS=' ' read -r mentorName mentorDomain _; do
    sudo chmod 750 "/home/Core/mentors/$mentorDomain/$mentorName"
    sudo chown "$mentorName":"$mentorName" "/home/Core/mentors/$mentorDomain/$mentorName"
done < "$mentorFile"

#Setting permission for each mentee
awk '{print $1}' "$menteeFile" | tail -n +2 | while IFS= read -r menteeName; do
    menteeHome="/home/Core/mentees/$menteeName"
    sudo chmod 700 "/home/Core/mentees/$menteeName"
    sudo chown "$menteeName":"$menteeName" "/home/Core/mentees/$menteeName"
done
# Allowing  Core to access everyone's home directory
while IFS=' ' read -r mentorName mentorDomain _; do
    sudo setfacl -m u:Core:rwx "/home/Core/mentors/${mentorDomain,,}/$mentorName"
done < "$mentorFile"

awk '{print $1}' "$menteeFile" | tail -n +2 | while IFS= read -r menteeName; do
    sudo setfacl -m u:Core:rwx "/home/Core/mentees/$menteeName"
done


