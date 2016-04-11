# Contributor: Steeve Chailloux <steeve@chaahk.com>
# Maintainer:
pkgname=apache-ant
pkgver=1.8.1
pkgrel=1
pkgdesc="A java-based build tool."
url="http://ant.apache.org/"
arch="noarch"
license="APACHE"
depends=""
depends_dev=""
makedepends="$depends_dev"
install=""
subpackages=""
source="
    http://archive.apache.org/dist/ant/binaries/${pkgname}-${pkgver}-bin.tar.bz2
    ${pkgname}.sh
    "

_builddir="${pkgname}-${pkgver}"
prepare() {
	local i
	cd "$_builddir"
	for i in $source; do
		case $i in
		*.patch) msg $i; patch -p1 -i "$srcdir"/$i || return 1;;
		esac
	done
}

build() {
    echo "Nothing to build using binaries"
}

package() {
	cd "src/$_builddir"

    # install profile.d script
    install -dm755 ${pkgdir}/etc/profile.d || return 1
    install -m644 ${srcdir}/${pkgname}.sh ${pkgdir}/etc/profile.d/ || return 1

    # Get the ANT_HOME env var
    source ${srcdir}/${pkgname}.sh || return 1

    cd ${srcdir}/${pkgname}-${pkgver}
    install -dm755 ${pkgdir}/${ANT_HOME}/bin || return 1
    install -dm755 ${pkgdir}/${ANT_HOME}/lib || return 1
    install -m644 ./lib/*.jar ${pkgdir}/${ANT_HOME}/lib || return 1
    cp -Rp ./etc ${pkgdir}/${ANT_HOME} || return 1

    # Do not copy Windows .bat/.cmd files
    find ./bin -type f -a ! -name \*.bat -a ! -name \*.cmd \
        -exec install -m755 {} ${pkgdir}/${ANT_HOME}/bin \; || return 1

    # symlink to junit so it's on the javac build path for ant
    # matches behavior on ubuntu 9 and makes sense for compatibility
    # http://bugs.archlinux.org/task/15229
    cd ${pkgdir}/usr/share/java/apache-ant/lib || return 1
    ln -s ../../junit.jar . || return 1
    cd - || return 1

    # The license says the NOTICE file should be redistributed for derivative
    # works, so lets supply it.
    install -dm755 ${pkgdir}/usr/share/licenses/${pkgname} || return 1
    install -m644 LICENSE NOTICE ${pkgdir}/usr/share/licenses/${pkgname} || return 1
}

md5sums="708cf4d654869146a0ab8410b8ae67fe  apache-ant-1.8.1-bin.tar.bz2
b3927e0f9f7a2204515ab223d8dfa1b0  apache-ant.sh"
sha256sums="e0c4e1133b0cb80dc4b29fc48f11b8f57e845e16474472f2749625be5cc66ca9  apache-ant-1.8.1-bin.tar.bz2
0cd8ae0f924fd70c302dc201258fc360be19818bb7c5adc2c71e59d5b16d0ce3  apache-ant.sh"
sha512sums="e430ef160f1369a7e191589ebb1223aecc9a67438e420fd2204f290e166910ecca9652844029f7dcf146803efbaa56ab06289f7eaf9118edfa353d82282984df  apache-ant-1.8.1-bin.tar.bz2
0ad68d446d9b6de8a164f2f217c6be9f0184c5bc89c2f1518bf98376d5839591d91747fc197270e47155eaf41025a736cc577b38b3c1e377f4889b2724a6ebb0  apache-ant.sh"
