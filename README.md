# Docker RuneLite (Selkies WebRTC)

An Ubuntu-based Docker container that runs the **RuneLite** client for Old School RuneScape (OSRS). It utilizes the **Selkies** WebRTC platform to stream the application directly to your web browser. Play OSRS anywhere, on your phone, at work, and resume playing on any system.

Great for AFK training, as you can connect to it only when needed, instead of keeping a computer online for it.

This project is built on top of `linuxserver/docker-baseimage-selkies` (Ubuntu Resolute variant)

## Features

* **Browser-based Access:** Stream RuneLite directly to any modern browser.
* **Persistent Configuration:** Keep your RuneLite settings, cache, and profiles safe across container restarts.
* **Audio Support:** Full audio streaming out of the box through Selkies.
* **Jagex Accounts:** Support for Jagex Accounts via [ccatss/goat-launcher](https://github.com/ccatss/goat-launcher) (see environment config for default launch options)

## Prerequisites

* Docker installed on your host system (Docker Desktop, Podman, Rancher Desktop, or a VPS work great too)
* Docker Compose (recommended for easier configuration).
* Optional: [GPU for video encoding/acceleration](https://github.com/linuxserver/docker-baseimage-selkies#gpu-acceleration)

## Quick Start

### Using Docker Compose (Recommended)

Create a `docker-compose.yml` file with the following configuration:

```yaml
version: '3.8'

services:
  runelite:
    image: ghcr.io/ccatss/docker-runelite # Replace with your image name/tag
    container_name: runelite
    shm_size: '2gb'
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - PASSWORD=your_secure_password # Optional: Add password protection
    volumes:
      - /path/to/config:/config # RuneLite files and application configs are stored here
    ports:
      - 3000:3000 # Web UI HTTP port
      - 3001:3001 # Web UI HTTPS port
    devices:
      - /dev/dri:/dev/dri # Optional: Disable this for non-GPU, RuneLite and Selkies run fine without it
    restart: unless-stopped
```

Run the following command to start the container:

```bash
docker-compose up -d
```

### Using Docker CLI

Alternatively, you can run the container using the standard Docker command line:

```bash
docker run -d \
  --name=runelite \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York \
  -e PASSWORD=your_secure_password \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --restart unless-stopped \
  ghcr.io/ccatss/docker-runelite:latest
```

## Usage

Once the container is running, open your web browser and navigate to:

* **HTTP:** http://localhost:3000
* **HTTPS:** https://localhost:3001

If you configured a `PASSWORD`, use `abc` as the username and your specified password to log in.

## Environment Variables

See [linuxserver/docker-baseimage-selkies](https://github.com/linuxserver/docker-baseimage-selkies) for full options.

| Variable             | Description                                                                    | Default |
|:---------------------|:-------------------------------------------------------------------------------| :--- |
| `PUID`               | User ID for file permissions on the host system                                | `1000` |
| `PGID`               | Group ID for file permissions on the host system                               | `1000` |
| `TZ`                 | Container timezone (e.g., `Europe/London`)                                     | `Etc/UTC` |
| `PASSWORD`           | Optional password protecting the web interface (User: `abc`)                   | None |
| `USE_JAGEX_LAUNCHER` | Use a Jagex Account Compatible launcher instead of launching RuneLite directly | None |

## Volumes

| Volume Path | Description |
| :--- | :--- |
| `/config` | Contains user settings, RuneLite client configurations, and application cache. |

## License

This project is open-source and available under the [ISC License](LICENSE).