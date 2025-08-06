#!/bin/bash

set -ouex pipefail

### Install packages

# this installs a package from fedora repos
dnf5 install -y atuin distrobox python3 python3-libselinux python3-libsemanage man-db mosh yq

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

rsync -rvK /ctx/system_files/etc/ /etc/

#### Example for enabling a System Unit File

systemctl enable cloud-init-custom.service
systemctl enable tailscaled.service
