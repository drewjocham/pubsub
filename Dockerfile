FROM google/cloud-sdk:alpine
RUN gcloud components install pubsub-emulator

FROM openjdk:8-jre-alpine

# Only copy what we need from cloud-sdk
COPY --from=0 /google-cloud-sdk/platform/pubsub-emulator /pubsub-emulator

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

ENV PUBSUB_EMULATOR_HOST=localhost:${PORT}
ENV PUBSUB_PROJECT_ID=${PROJECT}

CMD /pubsub-emulator/bin/cloud-pubsub-emulator --host=0.0.0.0 --port=${PORT} --project=${PROJECT}

HEALTHCHECK --interval=2s --start-period=15s --retries=5 \
   CMD sh -c "netstat -tulpen | grep 0.0.0.0:${PORT} || exit 1"

ENTRYPOINT ["/sbin/tini", "--"]
RUN ls -all

EXPOSE 8681
CMD [ "/bin/bash", "-l", "-c", "./run.sh"]
