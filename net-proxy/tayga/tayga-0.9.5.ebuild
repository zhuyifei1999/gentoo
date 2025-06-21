# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Out-of-kernel stateless NAT64 implementation based on TUN"
HOMEPAGE="https://github.com/apalrd/tayga"
SRC_URI="https://github.com/apalrd/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

src_prepare() {
	default

	sed -e '/^CFLAGS/d' -i Makefile || die "sed failed"

	export RELEASE="${PV}"
}

src_install() {
	dosbin tayga
	doman tayga.8
	doman tayga.conf.5

	systemd_dounit tayga.service
	systemd_dounit tayga@.service

	newconfd "${FILESDIR}"/tayga.confd ${PN}
	newinitd "${FILESDIR}"/tayga.initd ${PN}
}
