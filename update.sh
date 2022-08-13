#!/bin/bash

set -e

# Simple Script, Calculates The Sha512 Sums & updates the sums with version...

if [ -z "$1" ]; then
	echo "Error, Version Not Specified!"
else
	curl -L "https://github.com/pegvin/csprite/archive/refs/tags/v$1.tar.gz" --output archive.tar.gz
	curl -L "https://github.com/pegvin/csprite/releases/download/v$1/csprite-x86_64.elf" --output csprite-x86_64.elf

	SHA512_SUM=`sha512sum "./archive.tar.gz" | cut -d " " -f 1`
	X86_64_SUM=`sha512sum "./csprite-x86_64.elf" | cut -d " " -f 1`
	#I686_SUM=`sha512sum "./csprite-i686.elf" | cut -d " " -f 1`

	\cp templates/csprite/PKGBUILD csprite/PKGBUILD
	sed -i "s/__PACKAGE_VERSION__/$1/g" csprite/PKGBUILD
	sed -i "s/__ARCHIVE_SHA512_SUMS__/$SHA512_SUM/g" csprite/PKGBUILD

	cd csprite/
	makepkg --printsrcinfo > .SRCINFO
	cd ../

	\cp templates/csprite-bin/PKGBUILD csprite-bin/PKGBUILD
	sed -i "s/__PACKAGE_VERSION__/$1/g" csprite-bin/PKGBUILD
	sed -i "s/__ARCHIVE_SHA512_SUMS__/$SHA512_SUM/g" csprite-bin/PKGBUILD
	sed -i "s/__BINARY_X86_64_SUMS__/$X86_64_SUM/g" csprite-bin/PKGBUILD
	#sed -i "s/__BINARY_I686_SUMS__/$I686_SUM/g" csprite-bin/PKGBUILD

	cd csprite-bin/
	makepkg --printsrcinfo > .SRCINFO
	cd ../

	cd csprite-git/
	makepkg --printsrcinfo > .SRCINFO
	cd ../

	rm -f archive.tar.gz csprite-x86_64.elf csprite-i686.elf
fi
