#!/bin/bash 
#Reading username of mentee to check if mentee home directory exists 
read -p "Enter menteee username:" menteeName
read -p "Enter mentee rollno:" menteeRollno

if [ -d "/home/Core/mentees/$menteeName" ]; then
    
    echo "Enter your domain preferences (1-3) in preferred order (e.g., web sysad app):"
    read -r domain1 domain2 domain3
    echo "$domain1" > "$menteeHome/domain_pref.txt"
    [ -n "$domain2" ] && echo "$domain2" >> "/home/Core/mentees/$menteeName/domain_pref.txt"
    [ -n "$domain3" ] && echo "$domain3" >> "/home/Core/mentees/$menteeName/domain_pref.txt"

    # Appending roll number and domains to core's mentees_domain.txt file
    echo "$menteeRollNumber $domain1 $domain2 $domain3" >> "home/Core/mentees_domain.txt"

    #First checking if the domain is non empty then creating required sub directory 

    [ -n "$domain1" ] && mkdir -p "/home/Core/mentees/$menteeName/$domain1"
    [ -n "$domain2" ] && mkdir -p "/home/Core/mentees/$menteeName/$domain2"
    [ -n "$domain3" ] && mkdir -p "/home/Core/mentees/$menteeName/$domain3"
else
    echo "Error: Mentee's home directory does not exist."
fi
