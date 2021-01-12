FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

# use Japan_repo
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list
#apt upgdate
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
    git \
    openssh-server \
    python3.6-dev \
    python3-tk \
    python3-pip \  
    python3-setuptools \
    supervisor \
    sudo \
    xvfb \
    x11vnc \
    wget \
    curl \
    net-tools \
    vim-tiny \
    && pip3 install --upgrade pip

# install gym
RUN apt-get update \
# && apt-get -y install --no-install-recommends \
&& apt-get -y install \
python-numpy \
cmake \
zlib1g-dev \
libjpeg-dev \
xorg-dev \
python-opengl \
ffmpeg \
libboost-all-dev \
libsdl2-dev \
swig \
&& pip3 install gym

# clean apt cache
RUN apt-get clean \  
&& rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*  

# set up ssh
RUN mkdir -p /var/run/sshd

ARG ROOT_PASSWORD
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

USER root
WORKDIR /root
RUN echo "export DISPLAY=:0"  >> /etc/profile
EXPOSE 8080 22

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY startup.sh /startup.sh

RUN chmod 744 /startup.sh
# CMD ["/startup.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]