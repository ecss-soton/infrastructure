#! /bin/bash

# Scrips assumes repository is already cloned and in the correct directory

# Copy example env files to production env files
cp env/web_main.env.example env/web_main.env && cp env/web_sotonverify.env.example env/web_sotonverify.env && cp env/web_teamreg.env.example env/web_teamreg.env && cp env/bot_sotonverify.env.example env/bot_sotonverify.env

# Pull the latest images from the Docker Hub
docker compose pull

# Restart the containers
docker compose down
docker compose up -d
