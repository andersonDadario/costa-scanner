#!/bin/bash

echo "Starting period discovery infite loop..."
echo "To check logs type:"
echo "    docker exec -it <container name> tail -f app.log"
echo "Press [CTRL+C] to stop.."

service redis-server start
sleep 1
ruby action.rb &

while true
do
    echo "$(date) - Starting discovery..."
    ruby discovery.rb
    SLEEP_TIME=7200 # 2 hours
    echo "$(date) - Sleeping for $SLEEP_TIME seconds ..."
    sleep $SLEEP_TIME
done
