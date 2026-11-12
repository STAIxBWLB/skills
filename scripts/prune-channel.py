#!/usr/bin/env python3
"""Select skills-channel assets to prune.

Reads `gh release view skills-channel --json assets` JSON on stdin and prints
one asset name per line to delete: every asset of a revision outside the
newest KEEP revisions. The current revision and any asset whose name does not
parse as maru-skills-r<revision>-... are always kept.

Usage: prune-channel.py --keep 10 --current <run_id> < assets.json
       prune-channel.py --self-test
"""
import argparse
import json
import re
import sys

ASSET_RE = re.compile(r"^maru-skills-r(\d+)-")


def select(names, keep, current):
    by_rev = {}
    for name in names:
        m = ASSET_RE.match(name)
        if m:
            by_rev.setdefault(int(m.group(1)), []).append(name)
    kept = set(sorted(by_rev, reverse=True)[:keep])
    if current is not None:
        kept.add(current)
    return sorted(n for rev, ns in by_rev.items() if rev not in kept for n in ns)


def self_test():
    names = [f"maru-skills-r{i}-abc.{ext}" for i in range(1, 15) for ext in ("zip", "json")]
    names += ["README.txt", "maru-skills-latest.json"]
    # current outside the newest 10 is kept; unparsed names are never selected
    got = select(names, 10, 2)
    want = sorted(f"maru-skills-r{i}-abc.{ext}" for i in (1, 3, 4) for ext in ("zip", "json"))
    assert got == want, got
    # current inside the newest 10 changes nothing
    assert select(names, 10, 14) == sorted(
        f"maru-skills-r{i}-abc.{ext}" for i in (1, 2, 3, 4) for ext in ("zip", "json")
    )
    # fewer revisions than keep prunes nothing
    assert select(names[:6], 10, 3) == []
    print("prune-channel self-test ok")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--keep", type=int, default=10)
    ap.add_argument("--current", type=int)
    ap.add_argument("--self-test", action="store_true")
    args = ap.parse_args()
    if args.self_test:
        self_test()
        return
    if args.current is None:
        sys.exit("--current is required")
    if args.keep < 1:
        sys.exit("--keep must be >= 1")
    names = [a["name"] for a in json.load(sys.stdin)["assets"]]
    for name in select(names, args.keep, args.current):
        print(name)


if __name__ == "__main__":
    main()
