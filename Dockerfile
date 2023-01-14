ARG VARIANT="ubuntu-22.04"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# https://bobcares.com/blog/debian_frontendnoninteractive-docker/
ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

USER root
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  bash-completion \
                        i2c-tools \
                        libi2c0 \
                        libi2c-dev \
                        pip

# https://docs.docker.com/engine/install/ubuntu/
RUN apt-get install -y  ca-certificates \
                        curl \
                        gnupg \
                        lsb-release && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y  docker-ce \
                        docker-ce-cli \
                        containerd.io \
                        docker-compose-plugin

RUN usermod -a -G docker vscode

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt update && \
    apt install -y gh

RUN export POETRY_HOME=/opt/poetry && \
    export POETRY_VERSION=1.3.0 && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    echo "export PATH=/opt/poetry/bin:$PATH" > /etc/profile.d/poetry.sh

RUN pip install --no-warn-script-location  \
                ansible \
                ansible-lint \
                commitizen

RUN ansible-galaxy install gepaplexx.microk8s