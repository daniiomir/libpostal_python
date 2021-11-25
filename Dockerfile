FROM ubuntu:20.04

LABEL version="0.1" \
      maintainer="daniiomir@yandex.ru"

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt install -y curl autoconf automake libtool pkg-config git  \
    build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev  \
    libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev \
    && git clone https://github.com/openvenues/libpostal \
    && cd libpostal \
    && ./bootstrap.sh \
    && mkdir -p /data \
    && ./configure --datadir=/data/ \
    && make -j "$(nproc)" \
    && make install \
    && cd .. \
    && rm -rf libpostal \
    && cd /tmp/ \
    && wget https://www.python.org/ftp/python/3.8.11/Python-3.8.11.tgz \
    && tar -xf Python-3.8.11.tgz \
    && cd Python-3.8.11 \
    && ./configure --enable-optimizations \
    && make -j "$(nproc)" \
    && make altinstall \
    && cd .. \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python3.8 get-pip.py \
    && pip install postal \
    && rm -rf /tmp/* \
    && ln -s /usr/local/bin/python3.8 /usr/bin/python \
    && ln -s /usr/local/lib/python3.8/site-packages/pip /usr/bin/pip \
    && echo "export LD_LIBRARY_PATH=/usr/local/lib" >> /root/.bashrc \



