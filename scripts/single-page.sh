#!/usr/bin/env bash
# Turns a book's Verso single-page output into the edition published here.
#
# Usage: scripts/single-page.sh <book>/_out/html-single <destination>
#
# The book is rendered unmodified with `--with-html-single`, and the changes are made to its output
# rather than to its source, so that they keep applying as the book's source changes:
#  - The page's `base` element is removed. It sends links within the page to the directory rather
#    than to the page when the page is opened as `index.html`.
#  - Analytics scripts are removed.
#  - The styles and script in `overlay/` are added. They hide the site chrome, set the typography,
#    and rebuild the table of contents, whose links Verso leaves empty on the single page.
#  - The files the single page never loads (web fonts, the search and permalink pages) are left out.
set -euo pipefail

src=$1
dest=$2
overlay=$(cd "$(dirname "$0")/../overlay" && pwd)

page="$src/index.html"
if [ ! -f "$page" ]; then
  echo "no single-page output at $page" >&2
  exit 1
fi

rm -rf "$dest"
mkdir -p "$dest"
rsync -a \
  --exclude 'static/fonts/' \
  --exclude 'find/' \
  --exclude 'search/' \
  --exclude 'xref.json' \
  "$src/" "$dest/"

cp "$overlay/single.css" "$overlay/single.js" "$dest/static/"

# The `theme.css` link is here because the books pass its URL to `extraCss`, which expects the
# contents of a stylesheet, so the theme is otherwise never loaded.
head='<link rel="stylesheet" href="static/theme.css"><link rel="stylesheet" href="static/single.css"><script src="static/single.js" defer="defer"></script>'
HEAD_TAGS=$head perl -0pi -e '
  s{<base href="\./">}{}g;
  s{<script[^>]*plausible[^>]*></script>}{}g;
  s{</head>}{$ENV{HEAD_TAGS}</head>};
' "$dest/index.html"

if grep -rlE 'plausible|googletagmanager|google-analytics|gtag\(' "$dest"; then
  echo "tracking script left in $dest" >&2
  exit 1
fi
if grep -q '<base ' "$dest/index.html" || ! grep -q 'static/single.js' "$dest/index.html"; then
  echo "post-processing did not apply to $dest/index.html" >&2
  exit 1
fi

du -sh "$dest"
