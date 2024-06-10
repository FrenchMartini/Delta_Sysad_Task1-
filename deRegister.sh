#!/bin/bash 
user=$(whoami)
#Reading the names again and checking if the user is a mentee 
awk '{print $1}' "/home/adithya/Desktop/Delta_Sysad/menteeDetails.txt" | tail -n +2 | while IFS= read -r name; do
    if [[ "$user" == "$name" ]]; then 
        echo " Welcome mentee"
    else 
        echo "Permission not granted"
    fi 
done 

echo "Enter the domains you want to deregister  (e.g., web app )"
read domain1 domain2 domain3 
#Removing domain dir for the domains entered by the user 
[ -n "$domain1" ] && rmdir -r "/home/Core/mentees/$user/$domain1"
[ -n "$domain2" ] && rmdir -r "/home/Core/mentees/$user/$domain2"
[ -n "$domain3" ] && rmdir -r "/home/Core/mentees/$user/$domain3"
