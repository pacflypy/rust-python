cdir=$(shell pwd)
url="https://github.com/RustPython/RustPython"
prefix=$(cdir)/usr/local
name="RustPython"
version="0.3.1"
arch=$(shell dpkg --print-architecture)

package=$(name)_$(version)_$(arch).deb

build:
	cd $(cdir)
	mkdir -p $(prefix)
	cargo install --git $(url) --root $(prefix)
	cargo install --git $(url) --features ssl --root $(prefix)
	rm -rf $(prefix)/.crates*

install:
	cd $(cdir)
	tar -cJf data.tar.xz ./usr
	tar -cJf control.tar.xz ./control ./postinst
	echo 2.0 > debian-binary
	ar rcs $(package) debian-binary control.tar.xz data.tar.xz

clean:
	cd $(cdir)
	rm -rf usr
	rm -rf control.tar.xz
	rm -rf data.tar.xz
	rm -rf debian-binary
	rm -rf control

generate:
	cd $(cdir)
	echo 'Package: rust-python' > control
	echo 'Version: 0.3.1' >> control
	echo 'Section: utils' >> control
	echo 'Priority: optional' >> control
	echo 'Architecture: $(arch)' >> control
	echo 'Depends: build-essential, make, libssl-dev' >> control
	echo 'Maintainer: Kevin Alexander Krefting <kakrefting@gmail.com>' >> control
	echo 'Description: A Python Interpreter written in Rust' >> control
	echo '' >> control


all:
	cd $(cdir)
	make generate
	make build
	make install
	make clean
