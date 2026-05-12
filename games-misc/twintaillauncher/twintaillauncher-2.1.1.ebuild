# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="A multi-platform launcher for your anime games"
HOMEPAGE="https://github.com/TwintailTeam/TwintailLauncher"
SRC_URI="https://github.com/TwintailTeam/TwintailLauncher/archive/refs/tags/ttl-v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test network-sandbox"

S="${WORKDIR}/TwintailLauncher-ttl-v${PV}"
DOCS=( README.md )

RDEPEND="
	dev-libs/glib
	dev-libs/libayatana-appindicator
	net-libs/webkit-gtk:4.1
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango
	x11-themes/hicolor-icon-theme
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-libs/openssl
	dev-libs/protobuf[protoc]
	dev-util/desktop-file-utils
	dev-vcs/git
	gnome-base/librsvg
	net-libs/nodejs[npm]
	|| (
		dev-lang/rust
		dev-lang/rust-bin
	)
	x11-misc/appmenu-gtk-module
"

src_prepare() {
	default

	sed -i \
		-e 's/"beforeBuildCommand": "pnpm build"/"beforeBuildCommand": "npm run build"/' \
		-e 's/"beforeDevCommand": "pnpm dev"/"beforeDevCommand": "npm run dev"/' \
		src-tauri/tauri.conf.json || die

	npm ci || die
}

src_compile() {
	npm run build:native -- --no-bundle || die
}

src_install() {
	einstalldocs

	dobin "src-tauri/target/release/twintaillauncher"

	exeinto "/usr/lib/twintaillauncher/resources"
	doexe "src-tauri/target/release/resources/winetricks"
	doexe "src-tauri/target/release/resources/reaper"

	insinto "/usr/lib/twintaillauncher/resources"
	doins "src-tauri/target/release/resources/hkrpg_patch.dll"

	domenu "twintaillauncher.desktop"

	newicon -s 32 "src-tauri/icons/32x32.png" "twintaillauncher.png"
	newicon -s 128 "src-tauri/icons/128x128.png" "twintaillauncher.png"

	insinto /usr/share/icons/hicolor/128x128@2/apps
	newins "src-tauri/icons/128x128@2x.png" "twintaillauncher.png"
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Optional runtime helper:"
	elog "  games-util/gamemode"

	elog "MangoHud is not in the main Gentoo tree."
	elog "Use the GURU overlay if you want games-util/mangohud."
}

pkg_postrm() {
	xdg_pkg_postrm
}
