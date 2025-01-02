SOPS_FILE := "./secrets/secretes.yaml"
VM := "vm1"
HOST := `hostname`
USER := "$USER"

default:
    @just switch

build host=HOST:
    nh os build . -H {{host}} --out-link ./results/system -- --show-trace

switch host=HOST:
    nh os switch . -H {{host}} 

build-home user=USER:
    nh home build . --out-link ./results/home -- --show-trace

switch-home user=USER:
    nh home switch .

build-vm host=VM:
    nixos-rebuild build-vm --flake .#{{host}} --out-link ./results/vm

run-vm host=VM: build-vm
    sudo ./results/vm/bin/run-{{host}}-vm