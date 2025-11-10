"""
archive.py — Move files/directories into a quarter-stamped archive folder.

Behavior
--------
Given one or more paths:
1) If the path is a directory, find the most recent edit date among *files in that directory tree*.
   - If the directory contains no files, fall back to the directory's own mtime.
2) If the path is a file, use the file's own edit date.
3) Move the path to: <archive_dir>/<YYYY>q<Q>-<BASENAME>
   - Example:  ~/archive/2025q4-org        (for directory 'org')
               ~/archive/2024q1-foo.txt    (for file 'foo.txt' last edited in Feb 2024)

Options
-------
--archive-dir PATH   Change the archive base directory (default: ~/archive)
--dry-run            Show what would be moved, but make no changes
--verbose            Print extra details

Examples
--------
archive.py org foo.txt
archive.py --archive-dir ~/myarchive --dry-run notes images
"""

from __future__ import annotations

import argparse
import os
import shutil
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Optional, Tuple


def human_time(ts: float) -> str:
    """Human readable local time string from timestamp."""
    return datetime.fromtimestamp(ts).strftime("%Y-%m-%d %H:%M:%S")


def quarter_stamp(dt: datetime) -> str:
    """Return 'YYYYqQ' from a datetime."""
    q = (dt.month - 1) // 3 + 1
    return f"{dt.year}q{q}"


def latest_file_mtime_in_tree(root: Path, verbose: bool = False) -> Optional[float]:
    """
    Walk `root` and return the max mtime among *files only*.
    Returns None if no files exist beneath root.
    """
    latest: Optional[float] = None
    # Use os.walk for speed and to avoid following symlinks by default.
    for dirpath, dirnames, filenames in os.walk(root, followlinks=False):
        # Skip the archive dir if it is inside root to avoid self-inclusion.
        for name in filenames:
            p = Path(dirpath) / name
            try:
                if p.is_file():
                    mt = p.stat().st_mtime
                    if latest is None or mt > latest:
                        latest = mt
                        if verbose:
                            print(f"[scan] new latest: {p} ({human_time(mt)})")
            except FileNotFoundError:
                # File could disappear during walk; ignore.
                continue
    return latest


def most_recent_edit(path: Path, verbose: bool = False) -> float:
    """
    Determine the relevant 'most recent edit' mtime (seconds since epoch)
    per the spec: for directories, use latest *file* mtime in tree;
    if none, use directory mtime. For files, use its mtime.
    """
    if path.is_dir():
        latest = latest_file_mtime_in_tree(path, verbose=verbose)
        if latest is not None:
            return latest
        # Fall back to directory mtime if there were no files.
        return path.stat().st_mtime
    else:
        return path.stat().st_mtime


def split_name_and_ext(p: Path) -> Tuple[str, str]:
    """
    Return (base_without_ext, ext_with_dot) while preserving multi-dot extensions.
    For directories, ext will be "".
    """
    if p.is_dir():
        return (p.name, "")
    # For files, use .suffixes to retain compound extensions like .tar.gz
    suffix = "".join(p.suffixes)
    if suffix:
        base = p.name[: -len(suffix)]
    else:
        base = p.name
    return (base, suffix)


def unique_target_path(
    target_dir: Path, raw_name: str, is_file: bool, ext: str = ""
) -> Path:
    """
    Ensure the target path doesn't overwrite an existing file/dir.
    For files, add -1, -2, ... before the extension.
    For directories, add -1, -2, ... at the end of the name.
    """
    if is_file:
        candidate = target_dir / f"{raw_name}{ext}"
        idx = 1
        while candidate.exists():
            candidate = target_dir / f"{raw_name}-{idx}{ext}"
            idx += 1
        return candidate
    else:
        candidate = target_dir / raw_name
        idx = 1
        while candidate.exists():
            candidate = target_dir / f"{raw_name}-{idx}"
            idx += 1
        return candidate


@dataclass
class MovePlan:
    src: Path
    dst: Path
    mtime: float


def compute_destination(
    src: Path, archive_dir: Path, verbose: bool = False
) -> MovePlan:
    """Compute the destination path according to the rules."""
    mt = most_recent_edit(src, verbose=verbose)
    dt = datetime.fromtimestamp(mt)
    qstamp = quarter_stamp(dt)
    base, ext = split_name_and_ext(src)
    tag = f"{qstamp}-{base}"
    is_file = src.is_file()
    dst = unique_target_path(archive_dir, tag, is_file=is_file, ext=ext)
    return MovePlan(src=src, dst=dst, mtime=mt)


def is_subpath(child: Path, parent: Path) -> bool:
    try:
        child.resolve().relative_to(parent.resolve())
        return True
    except Exception:
        return False


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description="Quarter-stamped archiver.")
    parser.add_argument(
        "paths",
        nargs="+",
        help="Files or directories to archive",
    )
    parser.add_argument(
        "--archive-dir",
        default=str(Path.home() / "archive"),
        help="Archive directory (default: ~/archive)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show planned moves without making changes",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Print extra scanning and decision details",
    )

    args = parser.parse_args(argv)
    archive_dir = Path(os.path.expanduser(args.archive_dir)).resolve()

    # Create archive dir if not dry-run.
    if not args.dry_run:
        archive_dir.mkdir(parents=True, exist_ok=True)

    exit_code = 0

    for raw in args.paths:
        src = Path(raw).expanduser()
        if not src.exists():
            print(f"[skip] Not found: {src}", file=sys.stderr)
            exit_code = 2
            continue

        # Prevent moving archive dir into itself or moving something *containing* the archive dir.
        if src.is_dir():
            if is_subpath(archive_dir, src):
                print(
                    f"[error] Archive directory '{archive_dir}' is inside source '{src}'. "
                    "Refusing to move to avoid recursive self-move.",
                    file=sys.stderr,
                )
                exit_code = 2
                continue

        try:
            plan = compute_destination(src, archive_dir, verbose=args.verbose)
        except Exception as e:
            print(
                f"[error] Failed computing destination for {src}: {e}", file=sys.stderr
            )
            exit_code = 2
            continue

        when = human_time(plan.mtime)
        if args.dry_run or args.verbose:
            print(f"[plan] {src} -> {plan.dst} (latest edit: {when})")

        if args.dry_run:
            continue

        try:
            # Ensure parent exists (already created above, but unique_target_path may add suffixes)
            plan.dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.move(str(plan.src), str(plan.dst))
        except Exception as e:
            print(f"[error] Failed to move {src} -> {plan.dst}: {e}", file=sys.stderr)
            exit_code = 2
            continue

    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
