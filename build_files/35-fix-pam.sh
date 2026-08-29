#!/bin/bash
set -euo pipefail

# 1. Fix PAM config per plasmalogin (Usa lo standard Fedora 'password-auth')
cat > /etc/pam.d/plasmalogin << 'EOF'
#%PAM-1.0
auth        include     password-auth
account     include     password-auth
password    include     password-auth
session     include     password-auth
EOF

# 2. Installa pam-kwallet per lo sblocco del portafogli al login
dnf5 install -y pam-kwallet kf6-kwallet

# 3. Installa plasma-workspace (include wrapper mancanti)
dnf5 install -y plasma-workspace

# 4. Installa firmware e driver video (critico per Wayland!)
dnf5 install -y mesa-dri-drivers mesa-va-drivers mesa-vulkan-drivers linux-firmware

# 5. Aggiungi utente kris a gruppi video (se esiste)
if id kris &>/dev/null; then
    usermod -aG video,render kris
fi

# 6. Disabilita SELinux (per test)
sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# 7. Authselect
authselect select sssd with-mkhomedir with-pammodules --force
