#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

log_info "Installing Raku runtime packages from allowlist"
install_from_list /usr/lib/raku-kris/config/packages-raku-runtime.txt

# Copy RakuOS runtime files into the image
log_info "Installing RakuOS runtime files"

# Copy CLI and libexec scripts
mkdir -p /usr/bin /usr/libexec/rakuos /usr/lib/systemd/system

cp /usr/lib/raku-kris/files/usr/bin/rakuos /usr/bin/
cp /usr/lib/raku-kris/files/usr/libexec/rakuos/*.sh /usr/libexec/rakuos/
cp /usr/lib/raku-kris/files/usr/lib/systemd/system/*.service /usr/lib/systemd/system/
cp /usr/lib/raku-kris/files/usr/lib/systemd/system/*.timer /usr/lib/systemd/system/

# Enable essential services
ln -sf /usr/lib/systemd/system/rakuos-overlay-mount.service /usr/lib/systemd/system/local-fs.target.wants/
ln -sf /usr/lib/systemd/system/rakuos-overlay-services.service /usr/lib/systemd/system/multi-user.target.wants/
ln -sf /usr/lib/systemd/system/rakuos-updater.timer /usr/lib/systemd/system/timers.target.wants/
ln -sf /usr/lib/systemd/system/rakuos-cache-clean.timer /usr/lib/systemd/system/timers.target.wants/

# Set executable permissions
chmod 0755 /usr/bin/rakuos
chmod 0755 /usr/libexec/rakuos/*.sh

# Copy repository configuration
mkdir -p /etc/yum.repos.d
cp /usr/lib/raku-kris/files/etc/yum.repos.d/rakuos.repo /etc/yum.repos.d/

log_info "RakuOS runtime files installed"

dnf clean all
rm -rf /var/cache/dnf
