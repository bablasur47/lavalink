FROM ghcr.io/lavalink-devs/lavalink:4-alpine

USER root
RUN apk add --no-cache python3

EXPOSE 10000

WORKDIR /opt/Lavalink

COPY application.yml /opt/Lavalink/application.yml

COPY server.py /opt/Lavalink/server.py

ENTRYPOINT ["python3", "/opt/Lavalink/server.py"]