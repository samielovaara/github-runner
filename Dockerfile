# Use an official Ubuntu image as the base
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    tar \
    gzip \
    sudo \
    git \
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for the runner
RUN useradd -m -s /bin/bash runner 

WORKDIR /home/runner

# Download and install the GitHub Actions runner
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.312.0/actions-runner-linux-x64-2.312.0.tar.gz && \
tar xzf actions-runner.tar.gz && \
rm -f actions-runner.tar.gz

# Copy the requirements file into the image
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN bash /home/runner/bin/installdependencies.sh

# Expose a port if needed (for debugging or remote access)
EXPOSE 8080

USER runner

# Entrypoint to start the runner
ENTRYPOINT ["bash"]