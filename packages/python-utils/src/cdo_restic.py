import argparse
import subprocess
import os
import sys
import yaml
from pathlib import Path


def eprint(*args, **kwargs):
    return print(*args, **kwargs, file=sys.stderr)


def load_secrets():
    secrets_path = Path(
        os.environ.get("MUTIX_SECRETS_PATH", "~/.local/secure/mutix/secrets.sops")
    )
    try:
        result = subprocess.run(
            ["sops", "--decrypt", secrets_path],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            encoding="utf-8",
        )
        return yaml.safe_load(result.stdout)
    except subprocess.CalledProcessError as e:
        eprint(f"Error decrypting secrets: {e.stderr}", file=sys.stderr)
        sys.exit(1)


def get_machine_secrets(secrets, machine):
    try:
        entry = secrets["restic"][machine]
        url = entry["url"]
        password = entry["password"]
        return url, password
    except KeyError:
        print(
            f"Could not find restic.{machine}.url or restic.{machine}.password in secrets.",
            file=sys.stderr,
        )
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Restic wrapper with SOPS-managed secrets"
    )
    parser.add_argument(
        "--machine", "-m", required=True, help="Machine name to look up in secrets"
    )
    parser.add_argument(
        "restic_args", nargs=argparse.REMAINDER, help="Arguments to pass to restic"
    )
    args = parser.parse_args()

    secrets = load_secrets()
    url, password = get_machine_secrets(secrets, args.machine)

    env = os.environ.copy()
    env["RESTIC_REPOSITORY"] = url
    env["RESTIC_PASSWORD"] = password

    restic_args = args.restic_args
    if restic_args and restic_args[0] == "--":
        restic_args = restic_args[1:]

    try:
        proc = subprocess.run(["restic"] + restic_args, env=env)
        sys.exit(proc.returncode)
    except FileNotFoundError:
        print("restic not found in PATH.", file=sys.stderr)
        sys.exit(127)


if __name__ == "__main__":
    main()
