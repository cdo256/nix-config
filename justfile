SOPS_FILE := "./secrets/secretes.yaml"
VM := "vm1"
HOST := `hostname`
USER := "$USER"

default:
    @just switch

build host=HOST:
    nh os build . -H {{host}}

switch host=HOST:
    nh os switch . -H {{host}} 

build-home user=USER:
    nh home build .

switch-home user=USER:
    nh home switch .

build-vm host=VM:
    nixos-rebuild build-vm --flake .#{{host}}

run-vm host=VM: build-vm
    sudo ./result/bin/run-{{host}}-vm