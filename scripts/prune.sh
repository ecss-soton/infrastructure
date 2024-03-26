#! /bin/bash

docker system prune -f --filter "until=48h"
