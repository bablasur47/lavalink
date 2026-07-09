# ==============================================================================
# 1. BASE IMAGE: Pulls lightweight Alpine Linux with Java pre-installed
# ==============================================================================
FROM ghcr.io/lavalink-devs/lavalink:4-alpine

# ==============================================================================
# 2. NETWORK STACK: Expose Render's mandatory web service port
# ==============================================================================
EXPOSE 10000

# Set working directory inside the container
WORKDIR /opt/Lavalink

# ==============================================================================
# 3. CONFIGURATION: Copy your local settings into the container environment
# ==============================================================================
COPY application.yml /opt/Lavalink/application.yml

# ==============================================================================
# 4. BUILD-STAGE OPTIMIZATION: Pre-download plugins to bypass ephemeral storage
# ==============================================================================
# This triggers a dry-run initialization phase during Render's cloud build step.
# It reads your application.yml, downloads Spotify/YouTube plugins, and bakes 
# them into the container image permanently so they don't wipe on server sleep.
RUN java -jar Lavalink.jar --plugins-only || true

# ==============================================================================
# 5. EXECUTION LAYER: Boot command to run the audio server process
# ==============================================================================
ENTRYPOINT ["java", "-jar", "Lavalink.jar"]