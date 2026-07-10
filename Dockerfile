FROM ghcr.io/lavalink-devs/lavalink:4-alpine

EXPOSE 10000

WORKDIR /opt/Lavalink

COPY application.yml /opt/Lavalink/application.yml

ENTRYPOINT ["java", "-Xmx300M", "-Xms300M", "-jar", "Lavalink.jar"]