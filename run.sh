#!/bin/bash
echo "creating topics and subscriptions"
python3 publisher.py local create example
python3 subscriber.py local create example subscription
