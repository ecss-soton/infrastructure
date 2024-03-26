#!/bin/bash

# Remove files older than 30 days
find ~/infrastructure/backups/db/* -type f -mtime +30 -exec rm {} \;
find ~/infrastructure/backups/env/* -type f -mtime +30 -exec rm {} \;