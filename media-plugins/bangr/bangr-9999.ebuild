# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 toolchain-funcs

DESCRIPTION="Multi-dimensional dynamically distorted staggered multi-bandpass LV2 plugin"
HOMEPAGE="https://github.com/sjaehn/BAngr"
EGIT_REPO_URI="https://github.com/sjaehn/BAngr.git"
EGIT_BRANCH="master"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""

IUSE="debug"

DEPEND="
	x11-libs/libX11
	x11-libs/cairo
	media-libs/lv2
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-vcs/git
"

src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
	)

	use debug && myemakeargs+=( CPPFLAGS+=-g )

	emake "${myemakeargs[@]}"
}

src_install() {
	emake LV2DIR="${ED}/usr/lib64/lv2" install

	dodoc README.md
}

pkg_postinst() {
	elog "B.Angr has been installed to ${EROOT}/usr/lib64/lv2/BAngr.lv2/"
	elog "Any LV2 host (Ardour, Carla, Jalv, etc.) should detect it automatically."
	elog ""
	elog "Optional build-time customisations (rebuild after setting):"
	elog "  LANGUAGE=xx  – force a specific two-letter GUI language code"
	elog "  SKIN=name    – select an alternative plugin skin"
	elog "These can be passed via package.env or a local ebuild override."
}

