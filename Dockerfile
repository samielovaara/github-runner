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

# incase you need nopassword sudo rights for runner:
# RUN echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the runner user
WORKDIR /home/runner

# Download and install the GitHub Actions runner
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.312.0/actions-runner-linux-x64-2.312.0.tar.gz && \
tar xzf actions-runner.tar.gz && \
rm -f actions-runner.tar.gz

# Copy a script to configure the runner
COPY configure.sh /home/runner/configure.sh
RUN chmod +x configure.sh

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