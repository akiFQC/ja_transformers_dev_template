FROM nvidia/cuda:11.6.1-cudnn8-devel-ubuntu20.04
ENV TZ=Asia/Tokyo 

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /workspace
RUN apt-get update
RUN apt-get install -y software-properties-common tzdata
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get -y install \
    wget curl\
    libaio1 libaio-dev \
    cmake \
    git\
    bash \
    git\
    build-essential\
    libbz2-dev\
    libreadline-dev \
    libsqlite3-dev \
    default-jre \
    bzip2\
    llvm libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev\
    python3.9-dev python3.9-distutils python3-pip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt purge -y python3-yaml
RUN python3.9 -m pip install -U pip wheel setuptools


COPY ./requirements.txt /workspace/requirements.txt
RUN python3.9 -m pip install --upgrade pip && \
    python3.9 -m pip install -r requirements.txt
RUN python3.9 -m unidic download

# eport to set alias in .bashrc
RUN echo "alias python=python3.9" >> ~/.bashrc
RUN echo "alias pip=pip3.9" >> ~/.bashrc

RUN TORCH_CUDA_ARCH_LIST="7.0;7.5" DS_BUILD_CPU_ADAM=1 DS_BUILD_FUSED_ADAM=1 DS_BUILD_FUSED_LAMB=1 DS_BUILD_TRANSFORMER=1 DS_BUILD_TRANSFORMER_INFERENCE=1 DS_BUILD_UTILS=1 DS_BUILD_AIO=1 DS_BUILD_SPARSE_ATTN=1 python3.9 -m pip install  "transformers[deepspeed]" 
