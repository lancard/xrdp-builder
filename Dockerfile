FROM ubuntu:latest


ENV DEBIAN_FRONTEND=noninteractive
ENV XRDP_VERSION=0.10.4.1
ENV XRDP_SRC_DIR=/root/xrdp


RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget sudo systemctl -y

WORKDIR /root
RUN wget https://raw.githubusercontent.com/neutrinolabs/xrdp/refs/tags/v${XRDP_VERSION}/scripts/install_xrdp_build_dependencies_with_apt.sh
RUN chmod +x install_xrdp_build_dependencies_with_apt.sh
RUN ./install_xrdp_build_dependencies_with_apt.sh max

RUN ls -alR
WORKDIR /root/xrdp
RUN ./bootstrap
RUN ./configure --with-systemdsystemunitdir=/usr/lib/systemd/system --enable-ibus --enable-ipv6 --enable-jpeg --enable-fuse --enable-mp3lame --enable-fdkaac --enable-opus --enable-rfxcodec --enable-painter --enable-pixman --enable-utmp -with-imlib2 --with-freetype2 --enable-tests --enable-x264 --enable-openh264 --enable-vsock
RUN make
RUN make install
RUN ln -s /usr/local/sbin/xrdp{,-sesman} /usr/sbin

CMD tail -f /dev/null
