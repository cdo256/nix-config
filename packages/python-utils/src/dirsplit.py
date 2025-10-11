import os
import shutil
import sys


def move_files(file_paths, target_dir):
    os.makedirs(target_dir, exist_ok=True)
    cwd = os.getcwd()

    for path in file_paths:
        path = path.strip()
        if not path:
            continue

        abs_path = os.path.abspath(path)
        if not os.path.exists(abs_path):
            print(f"⚠️  Skipping (not found): {path}")
            continue

        # Preserve directory structure relative to current working directory
        rel_path = os.path.relpath(abs_path, cwd)
        dest_path = os.path.join(target_dir, rel_path)

        os.makedirs(os.path.dirname(dest_path), exist_ok=True)

        # Avoid overwriting existing files
        base, ext = os.path.splitext(dest_path)
        counter = 1
        while os.path.exists(dest_path):
            dest_path = f"{base}_{counter}{ext}"
            counter += 1

        shutil.move(abs_path, dest_path)
        print(f"✅ Moved: {path} → {dest_path}")

    print("\nDone!")


def main():
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Usage: dirsplit <target_directory> [file_list.txt]")
        sys.exit(1)

    target_dir = sys.argv[1]

    # Read file paths from stdin if no list file specified
    if len(sys.argv) == 2:
        print("Reading file list from stdin... (Ctrl+D or Ctrl+Z to end)")
        file_paths = sys.stdin.read().splitlines()
    else:
        list_file = sys.argv[2]
        with open(list_file, "r", encoding="utf-8") as f:
            file_paths = f.readlines()

    move_files(file_paths, target_dir)
