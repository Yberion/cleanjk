#!/bin/sh

set -e
set -v
set -x

ARCH="$1"
COMPILER="$2"
CPU_ARCH="$3"
CMAKE_VERSION="$4"

APT_GET_INSTALL='sudo -E apt-get -yq --no-install-suggests --no-install-recommends install'

if [ "${CPU_ARCH}" = "amd64" ]; then
	sudo mkdir -p "cmake-${CMAKE_VERSION}" && sudo wget -qO- "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz"  | sudo tar --strip-components=1 -xz -C "cmake-${CMAKE_VERSION}" ;
fi

case "${COMPILER}" in
	gcc)
		;;

	clang)
		sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
		;;
esac

sudo apt-get update -yq

case "${ARCH}" in
	x64)
		${APT_GET_INSTALL} \
			gcc-10 \
			g++-10 \
			libsdl2-dev
		;;

	x86)
		# libgcc-s1:i386 is needed before installing libc6:i386, it seems we can also use APT::Immediate-Configure=false (doesn't work)
		# https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1871268
		# https://github.com/Winetricks/winetricks/issues/1525
		${APT_GET_INSTALL} libgcc-s1:i386 ;;
		${APT_GET_INSTALL} \
			gcc-10-multilib \
			g++-10-multilib \
			libc6:i386 \
			libstdc++6:i386 \
			zlib1g-dev:i386 \
			libpng-dev:i386 \
			libjpeg-turbo8-dev:i386 \
			libsdl2-dev:i386
		;;
		
	x86_64-w64-mingw32)
		# Already installed
		#${APT_GET_INSTALL} g++-mingw-w64-x86-64
		;;

	i686-w64-mingw32)
		# Already installed
		#${APT_GET_INSTALL} g++-mingw-w64-i686
		;;
esac