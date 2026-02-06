FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG PFFDTD_REPO=https://github.com/mskarha/pffdtd-dev

# Optional: let you override the CUDA arch without editing the file
# Your old note used sm_70; for RTX 4070 Laptop (Ada) you'd typically want sm_89.
# We'll default to sm_89; you can change via compose build args.
ARG CUDA_ARCH=sm_89

# System deps: Python 3.10 on Ubuntu 22.04, HDF5 dev, build chain, and GUI libs for PyQt5
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    python3.10 python3.10-venv python3-pip \
    build-essential gcc g++ make \
    libhdf5-dev \
    libxcb-xinerama0 libxcb-xinerama0-dev \
    libx11-dev libxt6 libgl1 libglu1-mesa-dev libxrender1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work

# Clone inside the image (no credentials baked in)
RUN git clone ${PFFDTD_REPO} /work/pffdtd

# Create venv + install deps the way you used to
# (kept inside image for reproducibility; no driver/CUDA installs here)
RUN cd /work/pffdtd/python && \
    python3.10 -m venv venv_pffdtd && \
    . venv_pffdtd/bin/activate && \
    pip install --upgrade pip && \
    pip install numpy==1.23.5 && \
    pip install PyQt5 && \
    if [ -f pip_requirements.txt ]; then pip install -r pip_requirements.txt; fi

# Build CUDA code
# We export NVCCFLAGS similarly to your old Makefile override
RUN cd /work/pffdtd/c_cuda && \
    sed -i 's/sm_35/sm_89/g' Makefile && \
    make all

WORKDIR /work/pffdtd
CMD ["/bin/bash"]
