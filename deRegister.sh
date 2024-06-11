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

echo "Enter domains"
read domain1 domain2 domain3 

[ -n "$domain1" ] && rm -r "/home/Core/mentees/$user/$domain1"
[ -n "$domain2" ] && rm -r "/home/Core/mentees/$user/$domain2"
[ -n "$domain3" ] && rm -r "/home/Core/mentees/$user/$domain3"

echo "Removing directories of deregistered domains"

# Had errors when i did it directly putting a pattern to make things generalized 
pattern=""
[ -n "$domain1" ] && pattern="$pattern/$domain1/d;"
[ -n "$domain2" ] && pattern="$pattern/$domain2/d;"
[ -n "$domain3" ] && pattern="$pattern/$domain3/d;"

# If non empty then it deletes the required domain from the mentees domain file 
if [ -n "$pattern" ]; then
  sed -i "$pattern" "/home/adithya/Desktop/Task1Testing/Domains.txt"
fi

echo "Removed deregistered domains from domain.txt"