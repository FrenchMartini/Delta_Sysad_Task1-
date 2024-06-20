#Staring with the base image ubuntu 
FROM ubuntu

#Insatlling necesary packages 
RUN apt update 
RUN apt -y upgrade 
RUN apt install -y sudo acl wget git netcat at
RUN useradd -m -d /home/Core Core 
SHELL ["/bin/bash", "-c"]

# Copying the required scripts into the container 
COPY [ ".", "/home/adithya/Desktop/Delta_Sysad" ]

#Generating required users from the frist script 
RUN /home/adithya/Desktop/Delta_Sysad/userGen.sh 

#setting entrypoint path 
ENTRYPOINT [ "/home/adithya/Desktop/Delta_Sysad" ]





