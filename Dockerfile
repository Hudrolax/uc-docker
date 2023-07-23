FROM ubuntu:latest

EXPOSE 5900

COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
COPY ./scripts /scripts

RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    fluxbox \
    wget \
    unzip \
    gnupg \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install xterm
RUN apt-get update && apt-get install -y xterm

# Install Google Chrome from .deb (it's works only on x86 docker host machine, not ARM or Apple Silicon)
RUN apt-get update && apt-get install -y wget gnupg2 apt-utils --no-install-recommends \
    && wget --no-check-certificate https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || true \
    && apt-get install -fy \
    && rm -rf /var/lib/apt/lists/* google-chrome-stable_current_amd64.deb \
    && which google-chrome-stable || (echo 'Google Chrome was not installed' && exit 1)

# Install x11vnc
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd

# Install packages for python
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libffi-dev \
        libssl-dev \
        zlib1g-dev \
        liblzma-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev

# Download and install Python 3.10
WORKDIR /tmp2
RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz \
    && tar -xvf Python-3.10.0.tgz \
    && cd Python-3.10.0 \
    && ./configure --enable-optimizations \
    && make altinstall

# Download and install PIP manager for the Python 3.10
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3.10 get-pip.py

# Make venv and install python dependencies
RUN python3.10 -m venv /py && \
  /py/bin/pip install --upgrade pip && \
  /py/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
  rm /tmp/requirements.txt

WORKDIR /app

RUN chmod -R +x /scripts

ENV PATH="/scripts:/py/bin:$PATH"
ENV DISPLAY=:0

CMD startup.sh
