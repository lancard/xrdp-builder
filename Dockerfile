FROM ubuntu:latest

ARG GIT_REPO=https://github.com/neutrinolabs/xrdp.git
ARG GIT_BRANCH=devel
ENV GIT_REPO=${GIT_REPO}
ENV GIT_BRANCH=${GIT_BRANCH}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get git install wget sudo systemctl -y

WORKDIR /root

# get the sources and install dependencies
RUN git clone -b ${GIT_BRANCH} --single-branch ${GIT_REPO}
RUN /root/xrdp/scripts/install_xrdp_build_dependencies_with_apt.sh max

WORKDIR /root/xrdp

# build
RUN ./bootstrap
RUN ./configure --with-systemdsystemunitdir=/usr/lib/systemd/system --enable-ibus --enable-ipv6 --enable-jpeg --enable-fuse --enable-mp3lame --enable-fdkaac --enable-opus --enable-rfxcodec --enable-painter --enable-pixman --enable-utmp -with-imlib2 --with-freetype2 --enable-tests --enable-x264 --enable-openh264 --enable-vsock
RUN make
RUN make install
RUN ln -s /usr/local/sbin/xrdp{,-sesman} /usr/sbin

CMD tail -f /dev/null
