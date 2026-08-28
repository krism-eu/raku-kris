#!/bin/bash
set -euo pipefail

# Fix PAM config per plasmalogin (manca nel sistema)
cat > /etc/pam.d/plasmalogin << 'EOF'
#%PAM-1.0
auth include postlogin
account include postlogin
password include postlogin
session include postlogin
EOF

# Assicurati che pam-kwallet sia installato
dnf5 install -y pam-kwallet kf6-kwallet || true

# Configura authselect correttamente
authselect select sssd with-mkhomedir with-pammodules --force || true
