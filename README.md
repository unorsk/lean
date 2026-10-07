# Lean books

Single-page editions of [Functional Programming in Lean](https://github.com/leanprover/fp-lean) and
[Theorem Proving in Lean 4](https://github.com/leanprover/theorem_proving_in_lean4), published at
https://unorsk.github.io/lean/.

The [Books workflow](.github/workflows/books.yml) runs every night. When either book's `master`, or
this repository, has changed since the site was last built (the commits are in
[`versions.json`](https://unorsk.github.io/lean/versions.json)), it renders the books with Verso's
`--with-html-single`, adapts the pages with [`scripts/single-page.sh`](scripts/single-page.sh) and the
files in [`overlay/`](overlay/), and deploys the result together with [`site/`](site/). Run it from
the Actions tab with "force" to rebuild regardless.
