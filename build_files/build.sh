#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# TODO(ami): install these via brew post-boot?
dnf5 install -y tmux the_silver_searcher ripgrep glow alacritty

# hyprland
# some packages (hyprpaper) are no longer available in fedora 42, so trying this copr instead
# dnf5 -y copr enable solopasha/hyprland
# dnf5 install -y hyprland
# dnf5 install --skip-unavailable -y waybar hyprpaper dolphin dunst pavucontrol hypridle hyprlock kitty rofi-wayland mako
# dnf5 -y copr disable solopasha/hyprland

# Applets
dnf5 install -y blueman network-manager-applet

# Hardware-related tools
dnf5 install -y brightnessctl fprintd fprintd-pam

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

# lazygit
dnf -y copr enable dejan/lazygit
dnf -y install lazygit
dnf -y copr disable dejan/lazygit

# Tailscale - 26 Aug 2025 -- seems to be installed upstream now
#curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
#dnf5 install -y tailscale
#systemctl enable tailscaled

# 1Password
curl https://downloads.1password.com/linux/keys/1password.asc -o /etc/pki/rpm-gpg/1password.asc
cat > /etc/yum.repos.d/1password.repo << EOF
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/1password.asc
EOF

# Installing 1Password fails with:
#
# + mkdir -p /opt/1Password
# mkdir: cannot create directory '/opt': File exists
# is there a file named opt that's blocking us?
#mkdir -p /opt/1Password
#dnf5 install -y 1password 1password-cli

# Install cosmic desktop
dnf5 -y copr enable ryanabx/cosmic-epoch
dnf5 -y install cosmic-desktop
dnf5 -y copr disable ryanabx/cosmic-epoch

# Install some applet(s)
dnf5 -y copr enable wiiznokes/cosmic-applets-unofficial
dnf5 -y install cosmic-ext-applet-ollama
dnf5 -y install cosmic-ext-applet-minimon
dnf5 -y copr disable wiiznokes/cosmic-applets-unofficial

#### Example for enabling a System Unit File

systemctl enable podman.socket
