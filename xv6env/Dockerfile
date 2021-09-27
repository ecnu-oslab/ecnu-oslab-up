FROM ubuntu:bionic-20210827

RUN set -x && cp /etc/apt/sources.list /etc/apt/sources.list.bk && \
        sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
        apt-get clean && \
        apt update -y && \
        apt install -y \
        build-essential \
        gdb \
        gcc-multilib \
        gdb-multiarch \
        sudo \
        python2.7 \
        libglib2.0-dev \
        libpixman-1-dev \
        libfdt-dev \
        vim \
        grep 


RUN adduser alice && \
    echo alice:123456 | chpasswd && \
    usermod -aG sudo alice && \
    alias ls='ls --color=auto' && \
    alias grep='grep --color=auto' && \
    alias fgrep='fgrep --color=auto' && \
    alias egrep='egrep --color=auto'
   
USER alice
WORKDIR /home/alice


CMD ["/bin/bash"]
