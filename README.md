Create a bash file named run.sh

Example of file to create topics and subscriptions

#!/bin/bash
### Create topic
python3 publisher.py PROJECT_NAME create TOPIC_NAME
### Create subscription and bind to topic
python3 subscriber.py PROJECT_NAME create TOPIC_NAME SUNSCRIPTION_NAME

### Example
#!/bin/bash
python3 publisher.py local create example
python3 subscriber.py local create example subscription