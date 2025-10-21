#!/usr/bin/env python3
import sys
import subprocess
import argparse


def diff_size(ref_commit, other_commit):
    """Return total number of changed lines between ref_commit and other_commit."""
    cmd = ["git", "diff", "--shortstat", ref_commit, other_commit]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        output = result.stdout.strip()
        if not output:
            return 0
        # Example output: " 1 file changed, 3 insertions(+), 1 deletion(-)"
        total = sum(
            int(part) for part in output.replace(",", "").split() if part.isdigit()
        )
        return total
    except subprocess.CalledProcessError as e:
        # Print the meaningful Git error message to stderr
        if e.stderr:
            sys.stderr.write(
                f"git diff failed for {other_commit}:\n{e.stderr.strip()}\n"
            )
        else:
            sys.stderr.write(
                f"git diff failed for {other_commit} (no stderr):\n{e.stdout.strip()}\n"
            )
        return float("inf")


def parse_args():
    parser = argparse.ArgumentParser(
        description="Find the commit with the smallest diff relative to a reference commit."
    )
    parser.add_argument(
        "reference_commit",
        metavar="REFERENCE_COMMIT",
        help="Reference commit (hash, branch, tag, etc.)",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Print diff scores for each commit.",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    ref_commit = args.reference_commit.strip()
    commits = [line.strip() for line in sys.stdin if line.strip()]

    if not commits:
        sys.stderr.write("No commits provided on stdin.\n")
        sys.exit(2)

    smallest = None
    min_diff = float("inf")

    for commit in commits:
        diff = diff_size(ref_commit, commit)
        if args.verbose:
            print(f"{commit} {diff}")
        if diff < min_diff:
            min_diff = diff
            smallest = commit

    if smallest is not None:
        print(smallest)
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(130)
