import argparse
import subprocess
import os
import sys
import yaml
from pathlib import Path


def eprint(*args, **kwargs):
    return print(*args, **kwargs, file=sys.stderr)


def get_machine_secrets(file):
    try:
        result = subprocess.run(
            ["sops", "--decrypt", secrets_path],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            encoding="utf-8",
        )
        secrets = yaml.safe_load(result.stdout)
    except subprocess.CalledProcessError as e:
        eprint(f"Error decrypting secrets: {e.stderr}")
        sys.exit(1)

    try:
        entry = secrets["restic"]
        url = entry["url"]
        password = entry["key"]
        return url, password
    except KeyError:
        print(f"Could not find restic.url or restic.password in secret file.")
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

    default_secrets_path = (
        f"{os.environ["HOME"]}/.local/secure/mutix/hosts/{machine}.yaml"
    )
    secrets_path = Path(os.environ.get("MUTIX_SECRETS_PATH", default_secrets_path))
    url, password = get_machine_secrets(secrets_path)

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
        print("restic not found in PATH.")
        sys.exit(127)


if __name__ == "__main__":
    main()
