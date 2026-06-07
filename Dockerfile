FROM ghcr.io/linuxserver/baseimage-selkies:alpine323

RUN apk update && \
    apk add --no-cache \
    openjdk21-jre \
    mesa-dri-gallium \
    alsa-lib \
    curl

RUN mkdir -p /opt/runelite && \
    curl -L https://github.com/runelite/launcher/releases/latest/download/RuneLite.jar -o /opt/runelite/RuneLite.jar

COPY root/ /

RUN ln -sf /defaults/autostart /defaults/autostart_wayland && \
    chmod +x /defaults/autostart && \
    chown -R 1000:1000 /defaults

EXPOSE 3000 3001