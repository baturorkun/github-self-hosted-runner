# Use the official Ubuntu 22.04 image as a base
FROM  ubuntu:20.04
# Waiting ENVs
# Set environment variables
ENV RUNNER_HOME=/runner
ENV RUNNER_VERSION=2.321.0
ENV DOCKER_GROUP_ID=999
#ENV RUNNER_TOKEN=""
#ENV RUNNER_NAME="
#ENV RUNNER_LABELS=""
#ENV RUNNER_URL=https://github.com/YOUR_GITHUB_ORG
#ENV TZ=Europe/Istanbul

WORKDIR $RUNNER_HOME

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
    lsb-release

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt update && apt install -y docker-ce-cli

RUN rm -rf /var/lib/apt/lists/*

# check java version
RUN java -version

# check docker version
RUN docker -version

# Download and extract the GitHub Actions runner
RUN curl -o actions-runner-linux-x64.tar.gz -L \
    https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/actions-runner-linux-x64-$RUNNER_VERSION.tar.gz && \
    tar xzf ./actions-runner-linux-x64.tar.gz && \
    rm ./actions-runner-linux-x64.tar.gz

RUN pwd && ls -al

RUN DEBIAN_FRONTEND=noninteractive ./bin/installdependencies.sh

COPY start.sh start.sh
RUN chmod +x ./start.sh

RUN groupadd -g ${DOCKER_GROUP_ID} docker

RUN useradd -m runner

RUN usermod -aG docker runner

# Switch to the runner user
RUN chown -R runner:runner /runner
USER runner

# Configure the runner
CMD ["./start.sh"]