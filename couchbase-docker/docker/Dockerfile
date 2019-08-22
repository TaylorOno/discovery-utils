FROM couchbase:6.0.0

COPY entrypoint.sh entrypoint.sh
COPY initdb /initdb/

RUN chmod 755 entrypoint.sh \
    && chmod -R 755 initdb

VOLUME ["/initdb"]