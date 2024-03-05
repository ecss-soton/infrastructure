#! /bin/bash

mkdir -p backups

# Get the current date in the format YYYY-MM-DD
date=$(date +"%Y-%m-%d")

# Create a backup of the environment files
tar --exclude='*.example' -zcvf "env-backup-${date}".tar.gz env
