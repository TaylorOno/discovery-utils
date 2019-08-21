FROM openjdk:8u212-jre-alpine

ENV KAFKA_VERSION=2.3.0 \
    SCALA_VERSION=2.12 \
    KAFKA_HOME=/opt/kafka

COPY entrypoint.sh entrypoint.sh

RUN apk add --no-cache bash curl jq \
 && wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
 && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
 && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
 && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME}

CMD ["kafka"]