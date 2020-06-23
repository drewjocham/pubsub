#!/usr/bin/env bash
# START THE SERVER IN THE BACKGROUND
touch /pubsub.out
touch /run.log

checkConf=$(netstat -tulpen | grep 8681)
if [ -z "$checkConf" ]
then
    echo "Pubsub not running, starting pubsub."
    echo "Pubsub not running, starting pubsub." >>  /run.log
    /pubsub-emulator/bin/cloud-pubsub-emulator --host=0.0.0.0 --port=${PORT} --project=${PUBSUB_PROJECT_ID}  > /pubsub.out
fi
