# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

PLOCALES="af ak ar ast be bg bn_IN ca ca@valencia cgg da de el en_GB en_ZA es eu ff fi fo fr gl he is it ja lg lt nl nso pl pt pt_BR ru son st sv th tr uk vi zh_TW zu"

inherit distutils-r1 l10n

DESCRIPTION="A graphical translation tool"
HOMEPAGE="http://translate.sourceforge.net/wiki/virtaal/index"
SRC_URI="mirror://sourceforge/translate/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell tinytm +levenshtein +libproxy"

DEPEND="dev-python/translate-toolkit[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	tinytm? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
	spell? (
		app-text/iso-codes
		dev-python/pyenchant[${PYTHON_USEDEP}]
		dev-python/gtkspell-python[${PYTHON_USEDEP}]
	)
	levenshtein? ( dev-python/python-levenshtein[${PYTHON_USEDEP}] )
	libproxy? ( net-libs/libproxy )
	"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${P}-packaged.patch"
		"${FILESDIR}/${P}-QA-fix-MimeType.patch"
	)

	remove_locale() {
		sed -i -e "/${1}/ d" "${S}/po/LINGUAS" || die "Failed to remove ${1} locale."
	}

	l10n_for_each_disabled_locale_do remove_locale
	distutils-r1_python_prepare_all
}
