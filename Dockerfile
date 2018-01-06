FROM fedora:27
MAINTAINER Milosch Meriac <milosch@picodilly.io>

# add main user, give access to /opt
RUN \
	useradd -c "picodilly Developer" -G dialout -m picodilly && \
	chown picodilly /opt

# install development tools
RUN dnf makecache && dnf -y install \
	findutils \
	git \
	sudo \
	which \
	&& dnf clean all && rm -rf /var/cache/dnf/* && rm -f /var/lib/rpm/__db.*

# enabled root access for development
COPY sudoers /etc
RUN usermod -aG wheel picodilly

# temporary packages needed for building toolchain
ENV BUILD_PACKAGES \
	autoconf \
	automake \
	bc \
	bison \
	bzip2 \
	file \
	flex \
	gcc \
	gcc-c++ \
	gperf \
	help2man \
	libtool \
	ncurses-devel \
	patch \
	python-devel \
	tar \
	texinfo \
	unzip \
	wget

# install xtensa compiler toolchain ...
RUN dnf makecache && dnf -y install ${BUILD_PACKAGES} && \
	su -l picodilly -c '\
		git clone https://github.com/espressif/crosstool-ng && \
		cd crosstool-ng && \
		./bootstrap && \
		./configure --prefix=$PWD && \
		make && \
		make install && \
		export PATH=$PATH:$PWD/bin && \
		ct-ng xtensa-esp32-elf && \
		sed -i "s|^\(CT_PREFIX_DIR\)=.*$|\1=\"$HOME/local\"|g" .config && \
		ct-ng build.8 && \
		cd .. && \
		rm -rf crosstool-ng \
	' && \
		dnf -y remove ${BUILD_PACKAGES} && \
		dnf clean all && \
		rm -rf /var/cache/dnf/* && \
		rm -f /var/lib/rpm/__db.*
# ... and add it to the global search path
COPY profile-xtensa.sh /etc/profile.d/xtensa.sh

# add user configuration files
COPY gitconfig /home/picodilly/.gitconfig

# by default create a prompt
CMD ["/usr/bin/su","-l","picodilly"]
