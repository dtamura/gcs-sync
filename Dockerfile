FROM ubuntu:jammy

RUN set -e; \
    apt-get update -y && apt-get install -y \
    apt-transport-https ca-certificates gnupg \
    rsync ssh \
    curl \
    tini \
    lsb-release; \
    gcsFuseRepo=gcsfuse-`lsb_release -c -s`; \
    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y gcsfuse \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set fallback mount directory
ENV MNT_DIR /mnt/gcs

# Ensure the script is executable
COPY ./gcs-sync.sh /app/
RUN chmod +x /app/gcs-sync.sh

# Use tini to manage zombie processes and signal forwarding
# https://github.com/krallin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]


# Pass the startup script as arguments to Tini
CMD ["/app/gcs-sync.sh"]