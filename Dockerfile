FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

# Keep it simple: toolchain + libs you know you need
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git \
    python3.10 python3.10-venv python3-pip \
    build-essential gcc g++ make \
    libhdf5-dev \
    rsync file \
    libxcb-xinerama0 libxcb-xinerama0-dev \
    libx11-dev libxt6 libgl1 libglu1-mesa-dev libxrender1 \
    && rm -rf /var/lib/apt/lists/*

# Avoid locale warnings like the one you saw
RUN apt-get update && apt-get install -y --no-install-recommends locales && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

WORKDIR /work
CMD ["/bin/bash"]
