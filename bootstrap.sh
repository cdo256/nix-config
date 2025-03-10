#!/usr/bin/env -S bash -ex

export MIN_VERSION="2.22.0"
export NIX_CONFIG="experimental-features = nix-command flakes"

which nix || {
	curl -L https://nixos.org/nix/install >nix-install.sh
	chmod +x nix-install.sh
	sudo ./nix-install.sh --daemon --yes
}

VERSION=$(nix --version | grep -oP '\d+(\.\d+)+')

if [[ -z "$VERSION" ]]; then
	echo "Failed to extract version from nix"
	exit 1
fi

echo "Detected version: $VERSION"
echo "Upgrading to nix unstable..."
nix-channel --add https://nixos.org/channels/nixos-unstable nixos

echo "Upgrading nix to unstable..."
nix-channel --add https://nixos.org/channels/nixos-unstable nixos

version_gt() {
	# Returns true if $1 >= $2
	test "$(echo -e "$1\n$2" | sort -V | tail -n1)" == "$1"
}

if ! version_gt "$VERSION" "$MIN_VERSION"; then
	echo "Version $VERSION is less than $MIN_VERSION"
  echo "Updating"
  nix-channel --update
  nix-env -i nix
	exit 1
fi

mkdir -p /etc/profile.d
grep 'direnv' ~/.bashrc || echo 'eval "$(direnv hook bash)"' >>~/.bashrc
grep 'NIX_CONFIG' /etc/profile.d/nix.sh || echo 'export NIX_CONFIG="experimental-features = nix-command flakes"' | sudo tee -a /etc/profile.d/nix.sh
source /etc/profile.d/nix.sh

[[ -e ~/.profile ]] && source ~/.profile

nix-env -i direnv
nix-env -i nh
nix-env -i sops
nix-env -i just
nix-env -i yq
nix-env -i screen
# For terminfo
nix-env -i kitty
direnv allow

