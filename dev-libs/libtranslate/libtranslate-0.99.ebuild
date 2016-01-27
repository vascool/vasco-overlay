# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools

DESCRIPTION="Library for translating text and web pages between natural languages."
HOMEPAGE="http://www.nongnu.org/libtranslate"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="generic talkfilters"

RDEPEND=">=dev-libs/glib-2.4
	generic? (
		net-libs/libsoup:2.4
		>=dev-libs/libxml2-2
	)
	talkfilters? ( >=app-text/talkfilters-2.3.4-r1 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool"

src_prepare() {
	# Upstream patches for several minor issues.
	epatch "${FILESDIR}"/${P}-charsetparse.diff
	epatch "${FILESDIR}"/${P}-condfix.diff
	epatch "${FILESDIR}"/${P}-int64.diff
	epatch "${FILESDIR}"/${P}-man-page.diff
	epatch "${FILESDIR}"/${P}-libsoup24.diff

	# use services.xml from Fedora
	# http://pkgs.fedoraproject.org/cgit/rpms/libtranslate.git/
	cp "${FILESDIR}"/${PN}-services.xml-20100303 "${S}"/data/services.xml.in

	AT_M4DIR="${S}/m4" eautoreconf
}

src_configure() {
	econf \
		$(use_enable generic) \
		$(use_enable talkfilters)
}

src_test() {
	if has_version ${CATEGORY}/${PN}; then
		emake check || die
	else
		einfo "The test suite can only run after installation"
	fi
}

pkg_postinst() {
	elog "It is probably a good idea to maintain and update your own"
	elog "~/.libtranslate/services.xml file. See services.xml(5) for details."
}
