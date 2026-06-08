FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

ARG TARGETARCH

ENV TITLE=RuneLite \
    NO_FULL=true \
    NO_GAMEPAD=true

# Install RuneLite dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-21-jre \
    libgl1-mesa-dri \
    libasound2t64 \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Install Firefox
RUN \
  echo "**** install packages ****" && \
  add-apt-repository ppa:xtradeb/apps && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    firefox \
    ^firefox-locale && \
  echo "**** default firefox settings ****" && \
  FIREFOX_SETTING="/usr/lib/firefox/browser/defaults/preferences/firefox.js" && \
  echo 'pref("datareporting.policy.firstRunURL", "");' > ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.policy.dataSubmissionEnabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.healthreport.service.enabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.healthreport.uploadEnabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("trailhead.firstrun.branches", "nofirstrun-empty");' >> ${FIREFOX_SETTING} && \
  echo 'pref("browser.aboutwelcome.enabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("security.sandbox.warn_unprivileged_namespaces", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("network.protocol-handler.expose.jagex", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("network.protocol-handler.external.jagex", true);' >> ${FIREFOX_SETTING} && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# Install RuneLite
RUN mkdir -p /opt/runelite && \
    curl -L https://raw.githubusercontent.com/runelite/launcher/refs/heads/master/appimage/runelite.png \
      -o /opt/runelite/icon.png && \
    curl -L https://github.com/runelite/launcher/releases/latest/download/RuneLite.jar -o /opt/runelite/RuneLite.jar

# Install GoAT Launcher
RUN mkdir -p /opt/goat-launcher && \
    curl -L https://raw.githubusercontent.com/ccatss/goat-launcher/refs/heads/main/cmd/Icon.png \
        -o /opt/goat-launcher/icon.png && \
    curl -L https://github.com/ccatss/goat-launcher/releases/latest/download/goat-launcher-linux-${TARGETARCH}  \
        -o /opt/goat-launcher/goat-launcher && \
    chmod +x /opt/goat-launcher/goat-launcher

COPY root/ /

# Regenerate desktop mappings
RUN xdg-mime default goat-launcher.desktop x-scheme-handler/jagex

RUN ln -sf /defaults/autostart /defaults/autostart_wayland && \
    chmod +x /defaults/autostart && \
    chown -R 1000:1000 /defaults

EXPOSE 3000 3001