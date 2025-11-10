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
    if ! [[ -s /etc/sops/age/keys.txt ]]; then
        sudo nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 | sudo tee /etc/sops/age/keys.txt
        sudo chmod 0600 /etc/sops/age/keys.txt
    fi

generate-user-age-key: generate-ssh-key
    #!/usr/bin/env -S bash -x
    mkdir -p ~/.config/sops/age/
    if ! [[ -s ~/.config/sops/age/user-keys.txt ]]; then
        nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/user-keys.txt
        chmod 0600 ~/.config/sops/age/user-keys.txt
        echo "Generated user age key. Public key:"
        nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/user-keys.txt
    fi

add-sops-key: generate-age-key
    #!/usr/bin/env -S bash -x
    AGE_KEY=`sudo nix shell nixpkgs#age -c age-keygen -y /etc/sops/age/keys.txt`
    if grep -i "{{HOST}}" .sops.yaml; then
        echo "NOTE: {{HOST}} is already present in '.sops.yaml'. Refusing to override."
        exit 1
    fi
    sed -i "/^keys:/a\\  - &{{HOST}} $AGE_KEY" .sops.yaml
    sed -i "/^      - age:/a\\          - *{{HOST}}" .sops.yaml

add-user-sops-key: generate-user-age-key
    #!/usr/bin/env -S bash -x
    USER_AGE_KEY=`nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/user-keys.txt`
    if grep -i "{{HOST}}_user" .sops.yaml; then
        echo "NOTE: {{HOST}}_user is already present in '.sops.yaml'. Refusing to override."
        exit 1
    fi
    sed -i "/^keys:/a\\  - &{{HOST}}_user $USER_AGE_KEY" .sops.yaml
    sed -i "/^      - age:/a\\          - *{{HOST}}_user" .sops.yaml

try-add-sops-key:
    -! grep {{HOST}} .sops.yaml && just add-sops-key

add-age-key-to-secrets key:
    sops -r -i --add-age {{key}} secrets/secrets.yaml
    git add secrets
    git commit -m "Add {{HOST}} key to secrets.yaml."

bootstrap:
    just try-add-sops-key
