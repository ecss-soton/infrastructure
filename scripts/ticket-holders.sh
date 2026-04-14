#! /bin/bash
docker cp /home/cd6g22/infrastructure/doorlist.csv web_booking:/app/doorlist.csv

docker exec web_booking npm run getTicketHolders