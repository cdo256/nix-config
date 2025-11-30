import sys


def main():
    if len(sys.argv) < 2:
        raise SystemExit("usage: rot10 <digit-key>")

    key = sys.argv[1].strip()
    s = sys.stdin.read().strip()

    out = []
    for i, ch in enumerate(s):
        if ch.isdigit():
            k = int(key[i % len(key)])
            v = int(ch)
            out.append(str((v + k) % 10))
        else:
            out.append(ch)

    print("".join(out))


if __name__ == "__main__":
    main()
