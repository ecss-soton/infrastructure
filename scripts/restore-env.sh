#! /bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please provide a backup file to restore from as the first argument.'
    exit 0
fi

# Extract the backup
tar -xvzf $1 -C env
