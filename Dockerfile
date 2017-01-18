FROM fedora:25
MAINTAINER Milosch Meriac <milosch@picodilly.io>

# add main user, give access to /opt
RUN \
	useradd -c "picodilly Developer" -G dialout -m picodilly && \
	chown picodilly /opt

# install development tools
RUN dnf makecache && dnf -y install \
	autoconf \
	automake \
	bc \
	bzip2 \
	findutils \
	git \
	gcc \
	libstdc++ \
	make \
	mc \
	patch \
	python-pip \
	sudo \
	tar \
	unzip \
	wget \
	which \
	&& dnf clean all && rm -rf /var/cache/dnf/* && rm -f /var/lib/rpm/__db.*

# enabled root access for development
COPY sudoers /etc
RUN usermod -aG wheel picodilly

# temporary packages needed for building toolchain
ENV BUILD_PACKAGES \
	bison \
	file \
	flex \
	gcc-c++ \
	gperf \
	help2man \
	libtool \
	ncurses-devel \
	texinfo

# install xtensa compiler toolchain ...
RUN dnf makecache && dnf -y install ${BUILD_PACKAGES} && \
	su -l picodilly -c '\
		git clone https://github.com/picodilly/crosstool-NG && \
		cd crosstool-NG && \
		./bootstrap && \
		./configure --prefix=$PWD && \
		make && \
		make install && \
		export PATH=$PATH:$PWD/bin && \
		ct-ng xtensa-lx106-elf && \
		ct-ng build && \
		cd .. && \
		rm -rf crosstool-NG \
	' && \
		dnf -y remove ${BUILD_PACKAGES} && \
		dnf clean all && \
		rm -rf /var/cache/dnf/* && \
		rm -f /var/lib/rpm/__db.*
# ... and add it to the global search path
COPY profile-xtensa.sh /etc/profile.d/xtensa.sh

# install xtensa libhal
RUN su -l picodilly -c '\
		git clone https://github.com/picodilly/lx106-hal && \
		cd lx106-hal && \
		autoreconf -i && \
		mkdir build && \
		cd build && \
		../configure --prefix=/opt/xtensa-lx106-dev --host=xtensa-lx106-elf && \
		make && \
		sudo make install && \
		cd ../.. && \
		rm -rf lx106-hal \
	'

# install python-based esptool
RUN pip install --quiet --no-cache-dir esptool nodemcu-uploader

# add user configuration files
COPY gitconfig /home/picodilly/.gitconfig

# by default create a prompt
CMD ["/usr/bin/su","-l","picodilly"]
