FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:0.0

#apt upgdate
RUN apt-get update \
    && apt-get -y upgrade

RUN apt-get -y install --no-install-recommends \
    openssh-server \
    python3.6-dev python3-tk python3-pip \  
    python3-setuptools \
    git \
    wget \
    && pip3 install --upgrade pip

# install gym
RUN apt-get install -y python-numpy \
python-dev \
cmake \
zlib1g-dev \
libjpeg-dev \
xvfb \
xorg-dev \
python-opengl \
libboost-all-dev \
libsdl2-dev \
swig

RUN pip3 install gym

RUN mkdir /var/run/sshd

ARG ROOT_PASSWORD
RUN echo root:${ROOT_PASSWORD} | chpasswd

RUN sed -i 's/#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# set up noVNC
# RUN git clone https://github.com/kanaka/noVNC.git /opt/noVNC && \
#   cd /opt/noVNC && \
#   git checkout 6a90803feb124791960e3962e328aa3cfb729aeb && \
#   ln -s vnc_auto.html index.html
RUN mkdir -p /opt/noVNC/utils/websockify && \
    wget -qO- "http://github.com/novnc/noVNC/tarball/master" | tar -zx --strip-components=1 -C /opt/noVNC && \
    wget -qO- "https://github.com/novnc/websockify/tarball/master" | tar -zx --strip-components=1 -C /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html
# add user
RUN useradd -m -s /bin/bash user
RUN echo 'user:P@ssw0rd' | chpasswd

# clean apt cache
RUN apt-get clean \  
&& rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*  

WORKDIR /home/user/workspace
EXPOSE 6080 5900 22

CMD ["/usr/sbin/sshd", "-D"]