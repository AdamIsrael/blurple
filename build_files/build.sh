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

# Install Dropbox (install from the 42 repo, which might have the correct arch repo data?)
curl -L https://linux.dropbox.com/fedora/42/x86_64/nautilus-dropbox-2026.05.06-1.fc44.x86_64.rpm -o nautilus-dropbox-2026.05.06-1.fc44.x86_64.rpm
dnf5 -y install nautilus-dropbox-2026.05.06-1.fc44.x86_64.rpm

# curl -L https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-2026.01.15-1.fc43.x86_64.rpm -o nautilus-dropbox-2026.01.15-1.fc43.x86_64.rpm
# dnf5 -y install nautilus-dropbox-2026.01.15-1.fc43.x86_64.rpm

# Install MySQL Workbench
# dnf5 -y copr enable gui1ty/mysql-workbench-community
# dnf5 -y install mysql-workbench-community
# dnf5 -y copr disable gui1ty/mysql-workbench-community

# dnf -y install proj
# curl -L https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.44-1.el9.x86_64.rpm -o mysql-workbench.rpm
# dnf -y install mysql-workbench.rpm

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

# claude-desktop
curl -fsSL https://pkg.claude-desktop-debian.dev/rpm/claude-desktop-unofficial.repo -o /etc/yum.repos.d/claude-desktop-unofficial.repo
dnf -y install claude-desktop-unofficial

# fw-fanctrl: control the framework fan
dnf -y copr enable tulilirockz/fw-fanctrl
dnf -y install fw-fanctrl # if you just want ectool you can change this to fw-ectool
dnf -y copr disable tulilirockz/fw-fanctrl

# 1Password
/ctx/desktop-1password.sh

# disable uupd (for testing of renovatio
rm /usr/lib/systemd/system/uupd.service

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
