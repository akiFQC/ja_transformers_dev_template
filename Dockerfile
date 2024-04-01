FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04
ENV TZ=Asia/Tokyo 

# Install Python
ENV PYTHON_VERSION 3.10.12
ENV HOME /root
ENV PYTHON_ROOT /usr/local/python-$PYTHON_VERSION
ENV PATH $PYTHON_ROOT/bin:$PATH


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
    python3-dev \
    python3-distutils \
    python3-pip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*


RUN python3 -m pip install -U pip wheel setuptools


# install poetry - respects $POETRY_VERSION & $POETRY_HOME
# Poetryのインストール
ENV POETRY_HOME=${HOME}/.local/share/pypoetry
ENV PATH=${POETRY_HOME}/bin:${PATH}

RUN curl -sSL https://install.python-poetry.org | python3 -
RUN poetry config virtualenvs.in-project false && poetry completions bash >> ~/.bash_completion


COPY ./pyproject.toml ./poetry.lock* ./
RUN poetry install