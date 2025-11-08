#!/usr/bin/env python3
import sys
import os

CRED_FILE = os.path.expanduser("~/.git-credentials")


def parse_git_input():
    # Parse protocol, host, path, username from stdin (key=value)
    data = {}
    for line in sys.stdin:
        if "=" in line:
            key, value = line.strip().split("=", 1)
            data[key] = value
    return data


def read_credentials():
    if not os.path.isfile(CRED_FILE):
        return []
    creds = []
    with open(CRED_FILE) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            # Format: https://user:pass@host/path
            if "://" not in line or "@" not in line:
                continue
            proto, rest = line.split("://", 1)
            if "@" not in rest or ":" not in rest:
                continue
            userpass, hostpath = rest.split("@", 1)
            user, passwd = userpass.split(":", 1)
            host = hostpath.split("/", 1)[0]
            creds.append((proto, host, user, passwd))
    return creds


def main():
    action = os.environ.get("GIT_CREDENTIAL_HELPER_ACTION")
    if not action:
        # Fall back to using first argument, which git passes sometimes
        if len(sys.argv) > 1:
            action = sys.argv[1]
        else:
            action = "get"
    if action != "get":
        # Ignore store/erase requests for read-only mode
        sys.exit(0)

    query = parse_git_input()
    proto = query.get("protocol")
    host = query.get("host")
    username = query.get("username")
    creds = read_credentials()
    for c_proto, c_host, c_user, c_pass in creds:
        if proto == c_proto and host == c_host and (not username or username == c_user):
            # Output matching credential in git's expected format
            print(f"username={c_user}")
            print(f"password={c_pass}")
            return
    # If no match, print nothing (Git treats as 'not found')
    sys.exit(0)


if __name__ == "__main__":
    main()
