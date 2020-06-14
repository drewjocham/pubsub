#!/bin/bash
echo "creating topics and subscriptions"
python3 publisher.py local create mock_topic
python3 subscriber.py local create mock_topic mock_subscription
