# Christina's NixOS configuration

This repo contains my NixOS config, as well as my home-manager configurations. It can be used as a complete NixOS configuration, or on a foreign distribution, for example a server. It contains bootstrap scripts to install Nix, install some basic packages and create and setup a sops key.

## Steps to install on debian

This requires a user account in the `sudo` group with no sudo password (since sudo is being used inside the scripts). It also requires the machine to have a distinct hostname.

First install git,

```bash
sudo apt install git
```

Then make sure the src directory is present,

```bash
mkdir ~/src
```

Next we want to clone this repo,

```bash
git clone https://github.com/cdo256/nix-config ~/src/nix-config
cd ~/src/nix-config
```

Now you should be able to run the first bootstrap script,

```bash
./bootstrap.sh
```

This will install Nix, and add some packages that we might need.

If this succeeds, we next want to setup the key. First we nee to reload the profile to get the updated Nix variables such as $PATH.

```bash
. ~/.profile
just bootstrap
```

If this succeeds, you should see the machine and an Age key appear in `./.sops.yaml`. Commit this file, and push it so that you can be added to they keychain for `./secrets/secrets.yaml`.

Then on a machine with access, you'll need to pull those changes and run,

```bash
just add-age-key-to-secrets
git push
```

## Inspiration:

This NixOS configuration is based off the following people's Nix configuraiton. Thank you!!

- [vimjoyer](https://github.com/vimjoyer)
- [isabelroses](https://github.com/isabelroses)
- [ryan4yin](https://github.com/ryan4yin)
- [certifiKate](https://github.com/certifiKate)
- [jvanbruegge](https://github.com/jvanbruegge)

I hope that my configuration can serve as inspiration for many more people using NixOS!
