# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Out-of-kernel stateless NAT64 implementation based on TUN"
HOMEPAGE="https://github.com/apalrd/tayga"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/apalrd/tayga.git"
	EGIT_COMMIT=refs/pull/107/head
	inherit git-r3
else
	SRC_URI="https://github.com/apalrd/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

LICENSE="GPL-2"
SLOT="0"

src_prepare() {
	default

	if [[ ${PV} != 9999 ]] ; then
		export RELEASE="${PV}"
	fi

	export prefix=/usr

	# Unconditionally install init scripts
	export OPENRC=/bin/true
	export SYSTEMCTL=/bin/true
}

pkg_postinst() {
	local src="${EROOT}/var/db/tayga"
	local dst="${EROOT}/var/lib/tayga"

	if [[ -d "${src}" ]]; then
		einfo "${src} exists. Upstream moved the state directory"
		einfo "to ${dst}. Attempting to follow suit..."

		if [[ -e "${dst}" ]]; then
			ewarn "${dst} exists, skipping move."
		else
			mv -- "${src}" "${dst}" || ewarn "Move failed."
		fi
	fi
}
