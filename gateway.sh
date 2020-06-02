#!/bin/bash
set -euo pipefail

# Then check if there is an STORJ_CONFIG_DIR provided, if not, abort.
if [ -z $STORJ_CONFIG_DIR ]; then
  echo "You did not set an STORJ_CONFIG_DIR environment variable. Aborting!"
  exit 1
fi

# Then check if there is an STORJ_ACCESS provided, if not, check if the Storj credentials were provided.
if [ -z $STORJ_ACCESS ]; then
  echo "You did not set an STORJ_ACCESS environment variable. Checking if settings were provided via other environment variables ..."
fi

# Abort if the STORJ_SAT_ADDRESS was not provided if an STORJ_ACCESS was not provided neither.
if [ -z $STORJ_ACCESS ] &&  [ -z $STORJ_SAT_ADDRESS ]; then
  echo "You need to set STORJ_SAT_ADDRESS environment variable. Aborting!"
  exit 1
fi

# Abort if the STORJ_API_KEY was not provided if an STORJ_ACCESS was not provided neither. 
if [ -z $STORJ_ACCESS ] && [ -z $STORJ_API_KEY ]; then
  echo "You need to set STORJ_API_KEY environment variable. Aborting!"
  exit 1
fi

if [[ ! -f "${STORJ_CONFIG_DIR}/config.yaml" ]]; then
  if [[ -z "${STORJ_ACCESS}" ]]; then
    /usr/local/bin/gateway setup --non-interactive --satellite-address "${STORJ_SAT_ADDRESS}" --api-key "${STORJ_API_KEY}" --passphrase "${STORJ_PASSPHRASE}"
  else
    /usr/local/bin/gateway setup --non-interactive --access "${STORJ_ACCESS}" --passphrase "${STORJ_PASSPHRASE}"
  fi
fi

# grab Minio access and secret keys from the Storj gateway config
AWS_ACCESS_KEY_ID=$(sed -n -e 's/^minio\.access-key: //p' /root/.local/share/storj/gateway/config.yaml)
AWS_SECRET_ACCESS_KEY=$(sed -n -e 's/^minio\.secret-key: //p' /root/.local/share/storj/gateway/config.yaml)

#set the aws access credentials from environment variables
echo $AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY > ~/.passwd-s3fs
chmod 600 ~/.passwd-s3fs

gateway run