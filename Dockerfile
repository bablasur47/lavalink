FROM ghcr.io/lavalink-devs/lavalink:4-alpine

EXPOSE 10000

WORKDIR /opt/Lavalink

COPY application.yml /opt/Lavalink/application.yml

RUN java -jar Lavalink.jar --plugins-only || true

ENTRYPOINT ["java", "-jar", "Lavalink.jar"]