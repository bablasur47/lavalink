FROM ghcr.io/lavalink-devs/lavalink:4-alpine

RUN apk add --no-cache python3

EXPOSE 10000

WORKDIR /opt/Lavalink

COPY application.yml /opt/Lavalink/application.yml

RUN java -jar Lavalink.jar --plugins-only || true

COPY server.py /opt/Lavalink/server.py

CMD ["python3", "/opt/Lavalink/server.py"]