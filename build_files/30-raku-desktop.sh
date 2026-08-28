#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/raku-kris/build/lib.sh

log_info "Installing RakuOS runtime and desktop RPMs"
# UNICA transazione: dnf5 Fedora originale installa tutto,
# incluso rum-dnf-shim, senza rischi di shim attivo a metà.
install_from_list /usr/lib/raku-kris/config/packages-raku-runtime.txt
install_from_list /usr/lib/raku-kris/config/packages-raku-desktop.txt

log_info "Configuring desktop defaults"
mkdir -p /etc/skel/.config
cat > /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc << 'EOF'
[General]
ActivityId=
ToolboxButtonVisible=false
EOF

mkdir -p /etc/sddm.conf.d 2>/dev/null || true
if [[ -d /etc/sddm.conf.d ]]; then
    cat > /etc/sddm.conf.d/rakuos.conf << 'EOF'
[Theme]
Current=breeze
EOF
fi

# NON usare dnf5 qui: potrebbe essere diventato lo shim.
rm -rf /var/cache/dnf /var/cache/rum /tmp/* /var/tmp/*
