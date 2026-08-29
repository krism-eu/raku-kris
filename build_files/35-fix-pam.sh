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

# 2. Aggiungi utente kris a gruppi video (se esiste)
if id kris &>/dev/null; then
    usermod -aG video,render kris
fi

# 3. Disabilita SELinux (per test)
sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# 4. Authselect
authselect select sssd with-mkhomedir with-pammodules --force
