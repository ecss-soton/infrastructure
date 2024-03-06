#! /bin/bash

# Clone data repository
git clone https://github.com/ecss-soton/new-web.git

# Copy the data from the cloned repository to the database container
docker cp new-web/data/dump/ecss-website-cms/. db_mongo:/ecss-website-cms
docker cp new-web/media/. db_mongo:/ecss-media

# Remove the cloned repository
rm -rf new-web
