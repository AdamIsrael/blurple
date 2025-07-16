#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux the_silver_searcher ripgrep glow

# hyprland
dnf5 install -y hyprland
dnf5 install --skip-unavailable -y waybar hyprpaper dolphin dunst pavucontrol hypridle hyprlock kitty rofi-wayland

# We're going to layer firefox so that we can natively integrate with the 1password application
dnf5 install -y firefox

# Install Dropbox
curl -L https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-2025.05.20-1.fc42.x86_64.rpm -o nautilus-dropbox-2025.05.20-1.fc42.x86_64.rpm
dnf5 -y install nautilus-dropbox-2025.05.20-1.fc42.x86_64.rpm

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# install ghostty: https://ghostty.org/docs/install/binary
dnf5 -y copr enable scottames/ghostty
dnf5 -y install ghostty
dnf5 -y copr disable scottames/ghostty

# Tailscale
curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
dnf5 install -y tailscale
systemctl enable tailscaled

#### Example for enabling a System Unit File

systemctl enable podman.socket
