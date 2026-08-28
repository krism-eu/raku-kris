#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/raku-kris/build/lib.sh

log_info "Installing RakuOS runtime RPMs"
install_from_list /usr/lib/raku-kris/config/packages-raku-runtime.txt

log_info "Installing RakuOS desktop RPMs"
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

dnf5 clean all
rm -rf /var/cache/dnf
