FROM fedora:25
MAINTAINER Milosch Meriac <milosch@picodilly.io>

# add main user, give access to /opt
RUN \
	useradd -c "picodilly Developer" -m picodilly && \
	chown picodilly /opt

# install development tools
RUN dnf makecache && dnf -y install \
	bzip2 \
	findutils \
	git \
	libstdc++ \
	make \
	patch \
	python-pip \
	sudo \
	tar \
	unzip \
	wget \
	which \
	&& dnf clean all && rm -rf /var/cache/dnf/* && rm -f /var/lib/rpm/__db.*

# install python-based esptool
RUN pip install --quiet --no-cache-dir esptool

# enabled root access for development
COPY sudoers /etc
RUN usermod -aG wheel picodilly

# temporary packages needed for building toolchain
ENV BUILD_PACKAGES \
	autoconf \
	bison \
	file \
	flex \
	gcc \
	gcc-c++ \
	gperf \
	help2man \
	libtool \
	ncurses-devel \
	texinfo

# install xtensa compiler toolchain
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

# add user configuration files
COPY gitconfig /home/picodilly/.gitconfig

# by default create a prompt
CMD ["/usr/bin/su","-l","picodilly"]
