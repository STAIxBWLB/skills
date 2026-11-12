#!/usr/bin/env python3
"""Select skills-channel assets to prune.

Reads `gh release view skills-channel --json assets` JSON on stdin and prints
one asset name per line to delete: every asset of a revision outside the
newest KEEP revisions. The current revision and any asset whose name does not
parse as maru-skills-r<revision>-... are always kept.

Usage: prune-channel.py --keep 10 --current <run_id> < assets.json
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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--keep", type=int, default=10)
    ap.add_argument("--current", type=int, required=True)
    args = ap.parse_args()
    if args.keep < 1:
        sys.exit("--keep must be >= 1")
    names = [a["name"] for a in json.load(sys.stdin)["assets"]]
    for name in select(names, args.keep, args.current):
        print(name)


if __name__ == "__main__":
    main()
