#! /bin/bash

# Pull the latest changes from the remote repository
git pull

# Pull the latest images from the Docker Hub
docker compose pull

# Restart the containers
docker compose down
docker compose up -d
