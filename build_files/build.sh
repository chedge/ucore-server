#!/bin/bash

set -ouex pipefail

### Install packages

# this installs a package from fedora repos
dnf5 install -y atuin borgbackup borgmatic distrobox gdu langpacks-en python3 python3-firewall python3-libselinux python3-libsemanage man-db mosh yq zsh

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

rsync -rvK /ctx/system_files/etc/ /etc/

NODEEXPORTERURL="$(curl -sL https://api.github.com/repos/prometheus/node_exporter/releases/latest | jq -r '.assets[].browser_download_url' | grep 'linux-amd64')"
NODEEXPORTERRELEASE="$(basename ${NODEEXPORTERURL} | rev | cut -d'.' -f 3- | rev)"
curl -sL -o /tmp/node_exporter.tar.gz "${NODEEXPORTERURL}"
tar -C /usr/bin/ -zxvf /tmp/node_exporter.tar.gz "${NODEEXPORTERRELEASE}/node_exporter" --strip-components 1
echo 'u node-exp - -' > /usr/lib/sysusers.d/node-exp.conf

#### Example for enabling a System Unit File

systemctl enable cloud-init-custom.service
systemctl enable tailscaled.service
