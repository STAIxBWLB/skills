"""Korean layout fix for a written .pptx.

Usage: python ko_fix.py deck.pptx [--font "Noto Sans CJK KR"] [-o out.pptx]

- Re-tags runs written as lang="en-US" to lang="ko-KR" (altLang="en-US").
  PowerPoint then wraps Hangul at word boundaries instead of mid-word.
- With --font, sets the theme's East Asian (<a:ea>) and Hangul (script="Hang")
  fonts, which pptxgenjs leaves empty, so Hangul does not fall back to the host default.
Rewrites the deck in place unless -o is given. Runs its self-checks first.
"""
import argparse
import os
import re
import tempfile
import zipfile

TEXT_PARTS = re.compile(r"ppt/(slides|slideLayouts|slideMasters|charts)/[^/]+\.xml$")
THEME_PART = re.compile(r"ppt/theme/theme\d+\.xml$")


def retag(xml: str) -> str:
    xml = xml.replace('lang="en-US" altLang="en-US"', 'lang="ko-KR" altLang="en-US"')
    return re.sub(r'lang="en-US"(?! altLang)', 'lang="ko-KR" altLang="en-US"', xml)


def set_theme_font(xml: str, font: str) -> str:
    hang = f'<a:font script="Hang" typeface="{font}"/>'

    def fix(block: str) -> str:
        block = re.sub(r'<a:ea typeface="[^"]*"', lambda _: f'<a:ea typeface="{font}"', block)
        if '<a:font script="Hang"' in block:
            return re.sub(r'<a:font script="Hang" typeface="[^"]*"/>', lambda _: hang, block)
        return re.sub(r"(<a:cs [^>]*/>|</a:cs>)", lambda m: m.group(1) + hang, block, count=1)

    return re.sub(r"<a:(majorFont|minorFont)>.*?</a:\1>", lambda m: fix(m.group(0)), xml, flags=re.S)


def selftest():
    assert retag('<a:rPr lang="en-US" b="1"/>') == '<a:rPr lang="ko-KR" altLang="en-US" b="1"/>'
    assert retag('<a:rPr lang="en-US" altLang="en-US"/>') == '<a:rPr lang="ko-KR" altLang="en-US"/>'
    t = '<a:minorFont><a:latin typeface="X"/><a:ea typeface=""/><a:cs typeface=""/></a:minorFont>'
    out = set_theme_font(t, "F")
    assert '<a:ea typeface="F"' in out and '<a:font script="Hang" typeface="F"/>' in out, out
    t2 = '<a:majorFont><a:ea typeface=""/><a:cs typeface=""/><a:font script="Hang" typeface="Old"/></a:majorFont>'
    assert set_theme_font(t2, "F").count('typeface="F"') == 2


def main():
    selftest()
    ap = argparse.ArgumentParser()
    ap.add_argument("deck")
    ap.add_argument("--font")
    ap.add_argument("-o", "--out")
    a = ap.parse_args()
    out = a.out or a.deck
    fd, tmp = tempfile.mkstemp(suffix=".pptx", dir=os.path.dirname(os.path.abspath(out)))
    os.close(fd)
    runs = 0
    with zipfile.ZipFile(a.deck) as zi, zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as zo:
        for item in zi.infolist():
            data = zi.read(item.filename)
            if TEXT_PARTS.match(item.filename):
                text = data.decode("utf-8")
                runs += text.count('lang="en-US"')
                data = retag(text).encode("utf-8")
            elif a.font and THEME_PART.match(item.filename):
                data = set_theme_font(data.decode("utf-8"), a.font).encode("utf-8")
            zo.writestr(item, data)
    os.replace(tmp, out)
    print(f"ko_fix: {runs} runs re-tagged ko-KR" + (f", theme Hangul font = {a.font}" if a.font else "") + f" -> {out}")


if __name__ == "__main__":
    main()
