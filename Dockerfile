FROM debian:bookworm

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        bc \
        ca-certificates \
        binutils \
        build-essential \
        bzip2 \
        cpio \
        file \
        git \
        gzip \
        libncurses-dev \
        make \
        patch \
        perl \
        python3 \
        rsync \
        sudo \
        tar \
        unzip \
        wget \
        xz-utils \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/entry.sh /usr/sbin/
ENTRYPOINT ["/usr/sbin/entry.sh"]

WORKDIR /build
