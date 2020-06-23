#!/bin/bash

#!/usr/bin/env bash
# CREATE THE LOGFILE
touch /pubsub.out
touch /run.log

# WAIT FOR THE SERVICE TO BE READY
while true
do
        checkConf=$(netstat -tulpen | grep 8681)
        echo $checkConf >> /wait.log
        if [ -z "$checkConf" ]
        then
            sleep 1
            echo "Waiting for pubsub to be ready..."
            echo "Waiting for pubsub to be ready..." >> /run.log
        else
            echo "Pubsub running creating topics..."
            echo "Pubsub running creating topics..." >> /run.log
            sleep 10
            break
        fi
done
cd /

python3 publisher.py local create mock_topic
python3 subscriber.py local create mock_topic mock_subscription
