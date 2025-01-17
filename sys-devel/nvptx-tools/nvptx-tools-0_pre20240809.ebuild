# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Collection of tools for use with nvptx-none GCC toolchains"
HOMEPAGE="https://github.com/SourceryTools/nvptx-tools https://gcc.gnu.org/wiki/nvptx https://gcc.gnu.org/wiki/Offloading"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/SourceryTools/nvptx-tools"
	inherit git-r3
else
	MY_COMMIT="a0c1fff6534a4df9fb17937c3c4a4b1071212029"
	SRC_URI="https://github.com/SourceryTools/nvptx-tools/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${MY_COMMIT}

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

BDEPEND="
	test? (
		dev-python/lit
		dev-util/dejagnu
	)
"

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	# Reject newlib-on-glibc type installs
	if [[ ${CTARGET} == ${CHOST} ]] ; then
		case ${CHOST} in
			*-newlib|nvptx-*) ;;
			*) die "Use sys-devel/crossdev to build a nvptx(-none) toolchain" ;;
		esac
	fi
}
