#!/bin/bash 
#Reading username of mentee to check if mentee home directory exists 
user=$(whoami)
awk '{print $1}' "menteeDetails.txt" | tail -n +2 | while IFS= read -r name; do
    if [[ "$user" == "$name" ]]; then 
        echo " Welcome mentee"
        break
    else 
        echo "Permission isnt granted"
        exit 0 
    fi 
done 

if [ -d "/home/Core/mentees/$user" ]; then
    
    echo "Enter your domain preferences (1-3) in preferred order (e.g., web sysad app):"
    read -r domain1 domain2 domain3
    echo "$domain1" > "/home/Core/mentees/$user/domain_pref.txt"
    [ -n "$domain2" ] && echo "$domain2" >> "/home/Core/mentees/$user/domain_pref.txt"
    [ -n "$domain3" ] && echo "$domain3" >> "/home/Core/mentees/$user/domain_pref.txt"

    # Appending roll number and domains to core's mentees_domain.txt file
    echo "$menteeRollNumber $domain1 $domain2 $domain3" >> "home/Core/mentees_domain.txt"

    #First checking if the domain is non empty then creating required sub directory 

    [ -n "$domain1" ] && mkdir -p "/home/Core/mentees/$user/$domain1"
    [ -n "$domain2" ] && mkdir -p "/home/Core/mentees/$user/$domain2"
    [ -n "$domain3" ] && mkdir -p "/home/Core/mentees/$user/$domain3"

fi
