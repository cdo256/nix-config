#!/bin/bash -ex

export MIN_VERSION="2.22.0"
export NIX_CONFIG="experimental-features = nix-command flakes"

which nix || {
	curl -L https://nixos.org/nix/install >nix-install.sh
	chmod +x nix-install.sh
	sudo ./nix-install.sh --daemon --yes
}

VERSION=$(nix --version | grep -oP '\d+(\.\d+)*')

if [[ -z "$VERSION" ]]; then
	echo "Failed to extract version from nix"
	exit 1
fi

echo "Detected version: $VERSION"

version_gt() {
	# Returns true if $1 >= $2
	test "$(echo -e "$1\n$2" | sort -V | tail -n1)" == "$1"
}

if ! version_gt "$VERSION" "$MIN_VERSION"; then
	echo "Version $VERSION is less than $MIN_VERSION"
	exit 1
fi

grep 'direnv' ~/.bashrc || echo 'eval "$(direnv hook bash)"' >>~/.bashrc
grep 'NIX_CONFIG' /etc/profile.d/nix.sh || echo 'export NIX_CONFIG="experimental-features = nix-command flakes"' | sudo tee -a /etc/profile.d/nix.sh

source ~/.profile

nix-env -iA nixpkgs.direnv
nix-env -iA nixpkgs.nh
nix-env -iA nixpkgs.sops
nix-env -iA nixpkgs.just
nix-env -iA nixpkgs.yq
direnv allow

