# Raku Kris — third attempt
# Stage order is intentional:
# Fedora bootc base → RakuOS runtime → KDE → RakuOS desktop → cleanup/validation.
# Do not call dnf5.real before 10-raku-runtime.sh provides and validates it.

ARG FEDORA_VERSION=44
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

# Phase 0: Prove that the Fedora bootc Minimal input remains a valid bootable image.
RUN /usr/lib/raku-kris/build/00-base-fedora.sh \
    && /usr/lib/raku-kris/tests/test-base.sh

# Phase 1: Install RakuOS runtime and establish dnf5.real before any Raku wrapper is used.
RUN /usr/lib/raku-kris/build/10-raku-runtime.sh \
    && /usr/lib/raku-kris/tests/test-raku-runtime.sh

# Phase 2: Install only the KDE session and required desktop plumbing.
RUN /usr/lib/raku-kris/build/20-kde.sh \
    && /usr/lib/raku-kris/tests/test-kde.sh

# Phase 3: Install RakuOS-facing desktop tools only after backend and KDE are available.
RUN /usr/lib/raku-kris/build/30-raku-desktop.sh \
    && /usr/lib/raku-kris/tests/test-raku-desktop.sh

# Phase 4: Cleanup is intentionally last; it must never hide dependency or install errors.
RUN /usr/lib/raku-kris/build/40-cleanup.sh \
    && /usr/lib/raku-kris/build/90-validate.sh \
    && bootc container lint
