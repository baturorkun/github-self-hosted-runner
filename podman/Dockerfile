# Use the official Ubuntu 22.04 image as a base
FROM  ubuntu:22.04

# Waiting ENVs
# Set environment variables
ENV RUNNER_HOME=/runner
ENV RUNNER_VERSION=2.321.0
ENV RUNNER_ALLOW_RUNASROOT=true
#ENV RUNNER_TOKEN=""
#ENV RUNNER_NAME="
#ENV RUNNER_LABELS=""
#ENV RUNNER_URL=https://github.com/YOUR_GITHUB_ORG
#ENV TZ=Europe/Istanbul

RUN export DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y tzdata && dpkg-reconfigure -f noninteractive tzdata

# Install dependencies
RUN apt install -y \
    curl \
    git \
    jq \
    bash \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    build-essential \
    runc \
    podman \
    podman-docker

RUN rm -rf /var/lib/apt/lists/*

# configure podman
RUN echo "[storage]" > /etc/containers/storage.conf && \
    echo 'driver = "vfs"' >> /etc/containers/storage.conf && \
    echo 'runroot = "/run/containers/storage"' >> /etc/containers/storage.conf && \
    echo 'graphroot = "/var/lib/containers/storage"' >> /etc/containers/storage.conf && \
    echo 'unqualified-search-registries = ["docker.io"]' > /etc/containers/registries.conf && \
    touch /etc/containers/nodocker && \
    touch /var/run/docker.sock

WORKDIR $RUNNER_HOME

RUN docker --version

# Download and extract the GitHub Actions runner
RUN curl -o actions-runner-linux-x64.tar.gz -L \
    https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/actions-runner-linux-x64-$RUNNER_VERSION.tar.gz && \
    tar xzf ./actions-runner-linux-x64.tar.gz && \
    rm ./actions-runner-linux-x64.tar.gz && \
    chmod +x ./bin/installdependencies.sh

RUN DEBIAN_FRONTEND=noninteractive ./bin/installdependencies.sh

COPY start.sh start.sh
RUN chmod +x ./start.sh

# Configure the runner
CMD ["./start.sh"]