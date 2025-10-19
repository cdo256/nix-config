import subprocess
import argparse


def list_refs(repo_path):
    result = subprocess.run(
        ["git", "-C", repo_path, "for-each-ref", "--format=%(refname)"],
        stdout=subprocess.PIPE,
        text=True,
    )
    refs = result.stdout.strip().split("\n")
    return refs


def count_diff_lines(worktree_path, ref, repo_path):
    # Compare the external worktree against ref in the repo using --no-index
    result = subprocess.run(
        ["git", "-C", repo_path, "diff", "--shortstat", ref, "--", "."],
        cwd=worktree_path,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    stat = result.stdout.strip()
    if not stat:
        return 0
    insertions = 0
    deletions = 0
    for token in stat.split(","):
        token = token.strip()
        if "insertion" in token:
            insertions = int(token.split(" ")[0])
        if "deletion" in token:
            deletions = int(token.split(" ")[0])
    return insertions + deletions


def main():
    parser = argparse.ArgumentParser(
        description="Find the closest main repo ref by diff to the supplied repo state."
    )
    parser.add_argument("main_repo", help="Path to main (reference) git repo")
    parser.add_argument("supplied_repo", help="Path to supplied repo state (committed)")
    args = parser.parse_args()

    refs = list_refs(args.main_repo)
    best_ref = None
    best_score = None
    for ref in refs:
        score = count_diff_lines(args.supplied_repo, ref, args.main_repo)
        print(f"Ref {ref} diff score: {score}")
        if best_score is None or score < best_score:
            best_score = score
            best_ref = ref
    print("\nClosest reference:")
    print(f"{best_ref} with diff score {best_score}")


if __name__ == "__main__":
    main()
