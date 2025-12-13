import sys


def main():
    if len(sys.argv) != 1:
        raise SystemExit("usage: rot16")

    key = input("key: ").strip()
    s = input("ciphertext: ").strip()

    out = []
    hexchars = "0123456789abcdef"

    for i, ch in enumerate(s):
        cl = ch.lower()
        if cl in hexchars:
            k = int(key[i % len(key)], 16)
            v = int(cl, 16)
            out.append(format((v + k) % 16, "x"))
        else:
            out.append(ch)

    print("".join(out))


if __name__ == "__main__":
    main()
