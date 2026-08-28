set shell := ["bash", "-euo", "pipefail", "-c"]

FEDORA_VERSION := "44"
image := "localhost/raku-kris:dev"

build:
    @echo "[Just] Building Raku Kris image (Fedora {{FEDORA_VERSION}})"
    podman build --build-arg FEDORA_VERSION={{FEDORA_VERSION}} -t {{image}} -f Containerfile .

lint:
    @echo "[Just] Running bootc container lint"
    podman run --rm --privileged --security-opt label=disable {{image}} bootc container lint

inspect:
    @echo "[Just] Inspecting local image"
    podman image inspect {{image}}

clean:
    @echo "[Just] Cleaning local build artifacts"
    -podman rmi {{image}} 2>/dev/null || true
    -rm -rf output/ artifacts/ *.iso *.qcow2 *.raw *.tar

# ISO generation is intentionally a future target using bootc-image-builder.
iso:
    @echo "[Just] ISO generation not yet implemented (requires bootc-image-builder)"
    @exit 1
