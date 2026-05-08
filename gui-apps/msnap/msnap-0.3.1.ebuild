# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Screenshot and annotation tool using grim, slurp and GPU Screen Recorder"
HOMEPAGE="https://github.com/atheeq-rhxn/msnap"
SRC_URI="https://github.com/atheeq-rhxn/msnap/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	gui-apps/grim
	gui-apps/slurp
	gui-apps/wl-clipboard
	x11-libs/libnotify
	media-video/gpu-screen-recorder
	media-video/ffmpeg
"
BDEPEND="virtual/pkgconfig"

src_compile() {
	emake build \
		PREFIX="${EPREFIX}/usr" \
		BINDIR="${EPREFIX}/usr/bin" \
		DATADIR="${EPREFIX}/usr/share" \
		SYSCONFDIR="${EPREFIX}/etc/xdg" \
		STATEDIR="${EPREFIX}/var/lib"
}

src_install() {
	emake install \
		PREFIX="${EPREFIX}/usr" \
		BINDIR="${EPREFIX}/usr/bin" \
		DATADIR="${EPREFIX}/usr/share" \
		SYSCONFDIR="${EPREFIX}/etc/xdg" \
		STATEDIR="${EPREFIX}/var/lib" \
		DESTDIR="${ED}"
}
