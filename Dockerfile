# Multi-stage build for testing minimal dotfiles
FROM ubuntu:24.04 AS base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    fish \
    vim \
    tmux \
    git \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create test user
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser:password" | chpasswd && \
    usermod -aG sudo testuser

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy dotfiles
COPY --chown=testuser:testuser . /home/testuser/dotfiles/

# Run setup script
WORKDIR /home/testuser/dotfiles
RUN bash setup.sh

# Default command
CMD ["/bin/bash"]

# Test stage for running automated tests
FROM base AS test

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    shellcheck \
    && rm -rf /var/lib/apt/lists/*

USER testuser
WORKDIR /home/testuser/dotfiles

# Run tests
CMD ["bash", "test.sh"]
