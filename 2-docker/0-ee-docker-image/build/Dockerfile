FROM busybox as source
RUN addgroup -S -g 1001 axonserver \
    && adduser -S -u 1001 -G axonserver -h /axonserver -D axonserver \
    && mkdir -p /axonserver/config /axonserver/data /axonserver/events /axonserver/log /axonserver/exts \
    && chown -R axonserver:axonserver /axonserver

FROM gcr.io/distroless/java:11

COPY --from=source /etc/passwd /etc/group /etc/
COPY --from=source --chown=axonserver /axonserver /axonserver

COPY --chown=axonserver axonserver.jar axonserver-cli.jar axonserver.properties /axonserver/

USER axonserver
WORKDIR /axonserver

VOLUME [ "/axonserver/config", "/axonserver/data", "/axonserver/events", "/axonserver/log", "/axonserver/exts", "/axonserver/plugins" ]
EXPOSE 8024/tcp 8124/tcp 8224/tcp

ENTRYPOINT [ "java", "-jar", "./axonserver.jar" ]
