#!/usr/bin/env python3
import sys


def normalize_lines(filename):
    lines = set()
    with open(filename) as f:
        for raw in f:
            # Remove comments
            line = raw.split("#", 1)[0]
            # Strip whitespace
            line = line.strip()
            # Ignore blank lines
            if line:
                lines.add(line)
    return lines


def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} FILE1 FILE2", file=sys.stderr)
        sys.exit(1)

    left_file, right_file = sys.argv[1:3]
    left_lines = normalize_lines(left_file)
    right_lines = normalize_lines(right_file)

    all_lines = sorted(left_lines | right_lines)
    for line in all_lines:
        in_left = line in left_lines
        in_right = line in right_lines
        if in_left and in_right:
            print(f"={line}")
        elif in_left:
            print(f"<{line}")
        elif in_right:
            print(f">{line}")


if __name__ == "__main__":
    main()
