# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="3D rendering module for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="qml vulkan"

RDEPEND="
	=dev-qt/qtbase-${PV}*:6[concurrent,gui,network,opengl,vulkan=,widgets]
	=dev-qt/qtshadertools-${PV}*:6
	media-libs/assimp:=
	qml? ( =dev-qt/qtdeclarative-${PV}*:6[widgets] )
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
		-DQT_FEATURE_qt3d_system_assimp=ON
	)

	qt6-build_src_configure
}
