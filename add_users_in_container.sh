#!/bin/bash
# This script will update the env.list file (file containing USERS environrment variable) and add the new users if there are any.
# Will check for new users at a given time interval (change sleep duration on line 33)

SLEEP_DURATION=5
# Change theses next two variables to set different permissions for files/directories
# These were default from vsftpd so change accordingly if necessary
FILE_PERMISSIONS=644
DIRECTORY_PERMISSIONS=755

FTP_DIRECTORY="/home"

add_users() {
  for u in $USERS; do
    read username passwd <<< $(echo $u | sed 's/:/ /g')

    # If account exists set password again 
    # In cases where password changes in env file
    if getent passwd "$username" >/dev/null 2>&1; then
      echo $u | chpasswd
    fi

    # If user account doesn't exist create it 
    # As well as their home directory 
    if ! getent passwd "$username" >/dev/null 2>&1; then
       useradd -m -s /usr/sbin/nologin $username
       echo $u | chpasswd
     fi
   done
}

 while true; do
   sleep $SLEEP_DURATION
   add_users
 done
