# Raku Kris Build Phases

This document describes the exact order and responsibilities of each build phase.

## Phase Order

```
00-base-fedora.sh       → Fedora bootc Minimal integrity
10-raku-runtime.sh      → RakuOS runtime (MUST provide dnf5.real)
test-raku-runtime.sh    → Validate dnf5.real is available
20-kde.sh               → KDE Plasma desktop
test-kde.sh             → Validate KDE components
30-raku-desktop.sh      → RakuOS desktop tools (Software Center, etc.)
test-raku-desktop.sh    → Validate desktop integration
40-cleanup.sh           → Audited package cleanup
90-validate.sh          → Static validation (checks dnf5.real exists)
bootc container lint    → Final bootc image validation
```

## Critical Dependencies

### Phase 1 (10-raku-runtime.sh) MUST:

1. Provide `dnf5.real` as a real binary or wrapper
2. NOT use `dnf5.real` during build (use `dnf` or `dnf5` from Fedora)
3. Copy RakuOS CLI and runtime scripts
4. Install systemd units for overlay management
5. Configure repository definitions

### Phase 2 (20-kde.sh) MUST:

1. Install only KDE packages from allowlist
2. NOT install broad metapackages like `@kde-desktop-environment`
3. Use `dnf` (Fedora's package manager), not `dnf5.real`

### Phase 3 (30-raku-desktop.sh) MUST:

1. Run AFTER KDE is installed
2. Install RakuOS desktop integration (Software Center, welcome app)
3. Copy desktop files, icons, and configuration
4. NOT modify base image packages

### Phase 4 (40-cleanup.sh) MUST:

1. Only remove packages from audited list
2. NEVER use `dnf remove ... || true`
3. Fail if unvetted removals are detected

### Phase 5 (90-validate.sh) MUST:

1. Verify `/sysroot` exists (bootc requirement)
2. Verify `bootc` binary is present
3. Verify `dnf5.real` is available (critical RakuOS requirement)
4. Validate systemd unit files syntax
5. NOT require running systemd (container-safe checks only)

## dnf5.real Implementation

The `dnf5.real` binary is the core of RakuOS overlay management. It must:

1. Be a real binary or wrapper, NOT a symlink to `dnf5`
2. Configure dnf5 to install into `/var/rakuos-overlay` (the persistent overlay)
3. Be available AFTER phase 1 completes
4. Be validated by `test-raku-runtime.sh` and `90-validate.sh`

### Temporary Scaffold Implementation

The current scaffold provides `dnf5.real` as a wrapper:

```bash
#!/usr/bin/env bash
if mountpoint -q /var/rakuos-overlay; then
    exec dnf5 --installroot=/var/rakuos-overlay "$@"
else
    exec dnf5 "$@"
fi
```

**This is NOT production-ready.** Production builds should:

- Use the real `dnf5.real` binary from RakuOS
- Implement proper overlay filesystem (partition, composefs, or ostree native)
- Handle package database synchronization between base and overlay

## Overlay Mount Strategy

Current implementation uses **tmpfs** for the overlay:

- Pros: Works on any bootc system, no partitioning required
- Cons: Not persistent across reboots

**Production options:**

1. **Dedicated partition** (`/dev/disk/by-label/rakuos-overlay`)
2. **composefs** overlay on top of bootc root
3. **ostree native** overlay mechanism

The systemd service `rakuos-overlay-mount.service` is enabled but the actual mount mechanism should be replaced for production.
