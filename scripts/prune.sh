#! /bin/bash

docker system prune -af --filter "until=48h"
