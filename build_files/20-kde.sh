#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/raku-kris/build/lib.sh

log_info "Installing KDE packages and video drivers from allowlist"
install_from_list /usr/lib/raku-kris/config/packages-kde-minimal.txt

# Installa dipendenze critiche per il login grafico (usando il vero dnf5 di Fedora)
dnf5 install -y pam-kwallet kf6-kwallet mesa-dri-drivers mesa-va-drivers mesa-vulkan-drivers linux-firmware

# Abilita il display manager (plasma-login, con fallback a sddm)
log_info "Enabling display manager"
mkdir -p /etc/systemd/system
if [[ -f /usr/lib/systemd/system/plasma-login.service ]]; then
    ln -sf /usr/lib/systemd/system/plasma-login.service /etc/systemd/system/display-manager.service
elif [[ -f /usr/lib/systemd/system/sddm.service ]]; then
    ln -sf /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
else
    log_error "No display manager service found (plasma-login or sddm)"
    exit 1
fi

dnf5 clean all
rm -rf /var/cache/dnf
