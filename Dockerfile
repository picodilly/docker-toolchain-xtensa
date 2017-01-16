FROM fedora:25
MAINTAINER Milosch Meriac <milosch@picodilly.io>

# add main user, give access to /opt
RUN \
	useradd -c "picodilly Developer" -m picodilly && \
	chown picodilly /opt

# install development tools
RUN dnf -y install \
	autoconf \
	bison \
	bzip2 \
	ccache \
	file \
	findutils \
	flex \
	gcc \
	gcc-c++ \
	git \
	gperf \
	help2man \
	libstdc++ \
	libtool \
	make \
	mc \
	ncurses-devel \
	patch \
	python-pip \
	sudo \
	tar \
	texinfo \
	unzip \
	wget \
	which \
	&& dnf clean all

# install python-based esptool
RUN pip install --quiet --no-cache-dir esptool

# enabled root access for development
COPY sudoers /etc
RUN usermod -aG wheel picodilly

# install xtensa compiler toolchain
RUN su -l picodilly -c '\
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
'

# by default create a prompt
CMD ["/usr/bin/su","-l","picodilly"]
