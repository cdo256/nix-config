SOPS_FILE := "./secrets/secretes.yaml"
VM := "vm1"
HOST := `hostname`
USER := "$USER"
EMAIL := 'cdo@mutix.org'

default:
    @just switch

build host=HOST:
    nh os build . -H {{host}} --out-link ./results/system -- --show-trace

switch host=HOST:
    nh os switch . -H {{host}} -- --show-trace

build-home kind="client":
    nh home build . -c {{kind}} --out-link ./results/home -- --show-trace

switch-home kind="client":
    nh home switch . -c {{kind}} -- --show-trace

build-vm host=VM:
    nh os build-vm -H {{host}} --out-link ./results/vm -- --show-trace

run-vm host=VM: build-vm
    sudo ./results/vm/bin/run-{{host}}-vm

generate-ssh-key:
    -! stat ~/.ssh/id_ed25519 && ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N '' -C {{EMAIL}}

generate-age-key: generate-ssh-key
    #!/usr/bin/env -S bash -x
    mkdir -p ~/.config/sops/age/
    if ! [[ -s ~/.config/sops/age/keys.txt ]]; then
        nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 >~/.config/sops/age/keys.txt
        chmod 0600 ~/.config/sops/age/keys.txt
    fi

add-sops-key: generate-age-key
    #!/usr/bin/env -S bash -x
    AGE_KEY=`nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt`
    if grep -i "{{HOST}}" .sops.yaml; then
      echo "NOTE: {{HOST}} is already present in '.sops.yaml'. Refusing to override."
      exit 1
    fi
    sed -i "/^keys:/a\\  - &{{HOST}} $AGE_KEY" .sops.yaml 
    sed -i "/^    - age:/a\\      - *{{HOST}}" .sops.yaml 

try-add-sops-key:
    -! grep {{HOST}} .sops.yaml && just add-sops-key

add-age-key-to-secrets key:
  sops -r -i --add-age {{key}} secrets/secrets.yaml

bootstrap:
  just try-add-sops-key
  just add-age-key-to-secrets ~/.config/sops/age/keys.txt

