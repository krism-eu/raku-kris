# Raku Kris — fourth attempt
# Fedora bootc base → RakuOS runtime repo → KDE → RakuOS RPMs → cleanup/validation.

ARG FEDORA_VERSION=41
FROM quay.io/bootc-devel/fedora-bootc-${FEDORA_VERSION}-minimal

LABEL containers.bootc=1 \
      ostree.bootable=1 \
      org.opencontainers.image.title="Raku Kris" \
      org.opencontainers.image.description="Experimental RakuOS-style KDE desktop built from Fedora bootc Minimal"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY build_files/ /usr/lib/raku-kris/build/
COPY config/ /usr/lib/raku-kris/config/
COPY system_files/ /usr/lib/raku-kris/files/
COPY tests/ /usr/lib/raku-kris/tests/

RUN chmod 0755 /usr/lib/raku-kris/build/*.sh /usr/lib/raku-kris/tests/*.sh

# Phase 0: Fedora bootc Minimal base
RUN /usr/lib/raku-kris/build/00-base-fedora.sh \
    && /usr/lib/raku-kris/tests/test-base.sh

# Phase 1: Setup RakuOS repository
RUN /usr/lib/raku-kris/build/10-raku-runtime.sh \
    && /usr/lib/raku-kris/tests/test-raku-runtime.sh

# Phase 2: Install KDE session using Fedora's native dnf5
RUN /usr/lib/raku-kris/build/20-kde.sh \
    && /usr/lib/raku-kris/tests/test-kde.sh

# Phase 3: Install RakuOS RPMs (rum-dnf-shim, rakuos-core) and desktop tools
RUN /usr/lib/raku-kris/build/30-raku-desktop.sh \
    && /usr/lib/raku-kris/tests/test-raku-desktop.sh

# Phase 4: Cleanup
RUN /usr/lib/raku-kris/build/40-cleanup.sh

# Phase 5: Static validation before lint
RUN /usr/lib/raku-kris/build/90-validate.sh \
    && bootc container lint
