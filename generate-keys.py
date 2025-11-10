#!/usr/bin/env nix-shell
#!nix-shell -i python -p "python312.withPackages (p: [])" -p sops -p age -p openssh
import subprocess as sp
import argparse
from pathlib import Path
import sys
import os

home_path = Path(os.getenv("HOME"))
ssh_priv_key_path = home_path / ".ssh/id_ed25519"
ssh_pub_key_path = home_path / ".ssh/id_ed25519.pub"
age_key_path = home_path / ".config/sops/age/keys.txt"
user_age_key_path = home_path / ".config/sops/age/user-keys.txt"

ap = argparse.ArgumentParser(prog="generate-keys.py")
ap.add_argument("email")
ap.add_argument("-r", "--regenerate", action="store_true")
ap.add_argument("-s", "--ssh", action="store_true")
ap.add_argument("-a", "--age", action="store_true")
ap.add_argument("-u", "--user", action="store_true")
args = ap.parse_args()
print(args)

if (args.regenerate and args.ssh) or not ssh_priv_key_path.exists():
    print(f"Generating ed25519 ssh key in {ssh_priv_key_path}...")
    sp.run(["ssh-keygen", "-t", "ed25519", "-C", args.email], capture_output=False)
    print("Done: ")
else:
    print(
        f"ed25519 ssh key already exists at path {ssh_priv_key_path}, not regenerating."
    )

if (args.regenerate and args.age) or not age_key_path.exists():
    print(f"Generating system age key {age_key_path} from ed25519 key...")
    p = sp.run(
        [
            "nix",
            "run",
            "nixpkgs#ssh-to-age",
            "--",
            "-private-key",
            "-i",
            ssh_priv_key_path,
        ],
        capture_output=True,
        text=True,
    )
    age_key_path.parent.mkdir(parents=True, exist_ok=True)
    with open(age_key_path, "w") as f:
        f.write(p.stdout)
    p = sp.run(
        ["nix", "shell", "nixpkgs#age", "-c", "age-keygen", "-y", age_key_path],
        stdout=sp.PIPE,
        stderr=None,
        text=True,
    )
    print("System age key public key:", p.stdout.strip())
    print("Done.")
else:
    print(f"System age key already exists at path {age_key_path}, not regenerating.")

if (args.regenerate and args.user) or not user_age_key_path.exists():
    print(f"Generating user age key {user_age_key_path}...")
    p = sp.run(
        ["nix", "shell", "nixpkgs#age", "-c", "age-keygen"],
        stdout=sp.PIPE,
        stderr=None,
        text=True,
    )
    user_age_key_path.parent.mkdir(parents=True, exist_ok=True)
    with open(user_age_key_path, "w") as f:
        f.write(p.stdout)
    p = sp.run(
        ["nix", "shell", "nixpkgs#age", "-c", "age-keygen", "-y", user_age_key_path],
        stdout=sp.PIPE,
        stderr=None,
        text=True,
    )
    print("User age key public key:", p.stdout.strip())
    print("Done.")
else:
    print(f"User age key already exists at path {user_age_key_path}, not regenerating.")
