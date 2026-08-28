#!/bin/bash
set -euo pipefail

# Fix PAM config per plasmalogin
cat > /etc/pam.d/plasmalogin << 'EOF'
#%PAM-1.0
auth include postlogin
account include postlogin
password include postlogin
session include postlogin
EOF

# pam-kwallet
dnf5 install -y pam-kwallet kf6-kwallet || true

# plasma-workspace (include wrapper mancanti)
dnf5 install -y plasma-workspace || true

# Installa firmware e driver video (critico per Wayland!)
dnf5 install -y mesa-dri-drivers mesa-va-drivers mesa-vulkan-drivers linux-firmware || true

# Aggiungi utente kris a gruppi video (se esiste)
if id kris &>/dev/null; then
    usermod -aG video,render kris || true
fi

# Disabilita SELinux (per test)
sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config || true

# Authselect
authselect select sssd with-mkhomedir with-pammodules --force || true
