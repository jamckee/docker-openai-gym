FROM ubuntu:16.04

#RUN apt-get update \
#    && apt-get install -y --no-install-recommends \
#    sudo \
#    vim \
# Clear the apt-cache we don't need anymore

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    sudo \
    vim.tiny \
    python3 \
    #python3-dev \
    python3-opengl \
    python3-pip \
    xvfb \
    x11-apps x11-utils \
    #xorg \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*
 
# Create pip symlinks and update pip
RUN ln -sf /usr/bin/pip3 /usr/local/bin/pip \
    && ln -sf /usr/bin/python3 /usr/local/bin/python \
    && pip install -U pip

# Install VNC Dependency
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir tensorflow
RUN pip install --no-cache-dir opencv-python
RUN pip install --no-cache-dir gym
RUN pip install --no-cache-dir gym[atari]
RUN pip install --no-cache-dir gym[box2d]
RUN pip install --no-cache-dir gym[classic_control]
    

# Switch back to teletype
ENV DEBIAN_FRONTEND teletype

# Create universe user
RUN useradd --create-home --shell /bin/bash gym \
    && usermod -aG sudo gym \
    && echo "gym ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER gym

#set our working directory
WORKDIR /home/gym/

# Cachebusting - Copy Roms
COPY . ./

#Run our entry script
ENTRYPOINT ["sh","./fakescreen.sh"]

