FROM google/cloud-sdk:alpine
RUN gcloud components install pubsub-emulator

FROM bellsoft/liberica-openjdk-alpine:8

# Only copy what we need from cloud-sdk
COPY --from=0 /google-cloud-sdk/platform/pubsub-emulator /pubsub-emulator

COPY ./start-pubsub-service.sh /start-pubsub-service.sh
#COPY ./create-topics-and-subscriptions.sh /run.sh

COPY ./publisher.py /
COPY ./subscriber.py /

RUN apk upgrade --no-cache \
  && apk add --no-cache \
    build-base \
    python3 \
    python3-dev \
    linux-headers \
  && pip3 install --no-cache-dir --upgrade pip \
  && rm -rf /var/cache/* \
  && rm -rf /root/.cache/*

RUN cd /usr/bin \
  && ln -sf python3 python \
  && ln -sf pip3 pip

RUN pip install google-cloud-pubsub
RUN apk --update --no-cache add tini bash

HEALTHCHECK --interval=2s --start-period=15s --retries=5 \
	 CMD netstat -an | grep ${PORT} > /dev/null; if [ 0 != $? ]; then exit 1; fi;

CMD nohup bash -c "/start-pubsub-service.sh &" && sleep 10 && "/run.sh"
