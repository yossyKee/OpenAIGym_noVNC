FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
ARG ROOT_PASSWORD

# change to Japanese server
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN apt-get update \
    && apt-get -y install --no-install-recommends \
    #install utilties
    git \
    openssh-server \
    supervisor \
    sudo \
    wget \
    curl \
    net-tools \
    vim-tiny \
    # install python3.6
    python3.6-dev \
    python3-tk \
    python3-pip \  
    python3-setuptools \
    # install display tools
    xvfb \
    x11vnc \
    && pip3 install --upgrade pip

# install gym and requirements. see "installing everything" on https://github.com/openai/gym 
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
libglu1-mesa-dev \
libgl1-mesa-dev \
libosmesa6-dev \
xvfb \
ffmpeg \
curl \
patchelf \
libglfw3 \
libglfw3-dev \
cmake \
zlib1g-dev \
swig \
&& pip3 install gym

# clean up cache
RUN apt-get clean \  
&& rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*  

# set up ssh
RUN mkdir -p /var/run/sshd
RUN echo root:${ROOT_PASSWORD} | chpasswd

RUN sed -i 's/#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# set up noVNC
RUN mkdir -p /opt/noVNC/utils/websockify && \
    wget -qO- "http://github.com/novnc/noVNC/tarball/master" | tar -zx --strip-components=1 -C /opt/noVNC && \
    wget -qO- "https://github.com/novnc/websockify/tarball/master" | tar -zx --strip-components=1 -C /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# add user
RUN useradd -m -s /bin/bash user
RUN echo user:${ROOT_PASSWORD} | chpasswd
WORKDIR /home/user/workspace

# set up fake display
USER root
WORKDIR /root
RUN echo "export DISPLAY=:0"  >> /etc/profile

# 8080 -> noVNC_port / 22 -> ssh_port
EXPOSE 8080 22

# use supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# COPY startup.sh /startup.sh
# RUN chmod 744 /startup.sh
# CMD ["/startup.sh"]