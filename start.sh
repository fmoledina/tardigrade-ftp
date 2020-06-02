#!/bin/bash
set -euo pipefail

# Check first if the required FTP_BUCKET variable was provided, if not, abort.
if [ -z $FTP_BUCKET ]; then
  echo "You need to set FTP_BUCKET environment variable. Aborting!"
  exit 1
fi

# Update the vsftpd.conf file to include the IP address provided by FTP_PASV_ADDRESS
if [ ! -z $FTP_PASV_ADDRESS ]; then
  sed -i "s/^#pasv_address=/pasv_address=$FTP_PASV_ADDRESS/" /etc/vsftpd.conf
fi

# Create FTP user and userdir
read username passwd <<< $(echo $FTP_USER | sed 's/:/ /g')
groupadd -g 1000 $username
useradd -M -s /usr/sbin/nologin -u 1000 -g 1000 $username
echo $FTP_USER | chpasswd

FTP_DIRECTORY="/srv/ftp/${username}"
mkdir -p $FTP_DIRECTORY
chown 1000:1000 $FTP_DIRECTORY
chmod 755 $FTP_DIRECTORY

# start s3 fuse
s3fs -f -d $FTP_BUCKET $FTP_DIRECTORY -o url=http://localhost:7777 -o use_path_request_style -o uid=1000 -o gid=1000 > /var/log/s3fs-start.log