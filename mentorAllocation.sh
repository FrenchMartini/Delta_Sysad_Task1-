#!/bin/bash 
user=$(whoami)
#First checking if user is Core 
if [[ $user == "Core" ]]; then 
    echo "Starting mentor allocation"
else 
    echo "Permission not granted"
fi 


# Reading info from mentordetails to tempfile acout mentor name, domain and capacities 
tempFile=$(mktemp)
awk 'NR > 1 {print $1, $2, $3}' "/home/Core/mentorDetails.txt" > "$tempFile"

# Using a function to allocate mentee
allocate_mentee() {
    local rollNumber="$1"
    local name="$2"
    local domain="$3"

    # First reads from temp file and checks if the domain is matching 
    # Then also checks if mentor has capacity left , then stores the name as mentor 
    mentor=$(awk -v domain="$domain" '$2 == domain && $3 > 0 {print $1; exit}' "$tempFile")
    
    if [ -n "$mentor" ]; then
        
         # Appending the roll number and name of mentee allocated  to the mentor's home directory 
        echo "$rollNumber $name" >> "/home/Core/mentors/$domain/$mentor/allocatedMentees.txt"

        # Decrement the mentor's capacity
        awk -v mentor="$mentor" '{
            if ($1 == mentor) {
                $3 -= 1
            }
            print
        }' "$tempFile" > "${tempFile}.tmp" && mv "${tempFile}.tmp" "$tempFile"


        return 0
    fi

    return 1
}

# trying to Make  a FCFS by first allocating all the first preferences of mentees then the second and so on 
preference_allocation() {
    local index="$1"

    # Read mentee from domainpref file in cores dir
    tail -n +2 "/home/Core/mentees_domain.txt" | while IFS=$'\t' read -r rollNumber name domain1 domain2 domain3; do
        case $index in
            1) domain="$domain1" ;;
            2) domain="$domain2" ;;
            3) domain="$domain3" ;;
            *) domain="" ;;
        esac

        # If domain is non empty , starting the allocation process by passing rollnumber, name and domain variables
        [ -n "$domain" ] && allocate_mentee "$rollNumber" "$name" "$domain"
    done
}

# Processing all mentees in order on how many prefs they have 
preference_allocation 1
preference_allocation 2
preference_allocation 3



# Cleaning  up temporary files created 
rm -f "$tempFile"

echo "Mentor allocation completed."
