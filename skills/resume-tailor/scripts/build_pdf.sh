#!/usr/bin/env bash
# Compile a LaTeX resume to PDF.
# Prefers Tectonic; falls back to any installed engine. If none is found,
# auto-installs Tectonic via Homebrew (a single self-contained LaTeX engine).
#
# Usage: build_pdf.sh <path-to-.tex>
set -euo pipefail

TEX_FILE="${1:?usage: build_pdf.sh <path-to-.tex>}"
if [ ! -f "$TEX_FILE" ]; then
  echo "ERROR: file not found: $TEX_FILE" >&2
  exit 1
fi

OUT_DIR="$(cd "$(dirname "$TEX_FILE")" && pwd)"
TEX_BASE="$(basename "$TEX_FILE")"
PDF_BASE="${TEX_BASE%.tex}.pdf"

find_engine() {
  for e in tectonic latexmk xelatex pdflatex; do
    if command -v "$e" >/dev/null 2>&1; then echo "$e"; return 0; fi
  done
  return 1
}

ENGINE="$(find_engine || true)"

if [ -z "${ENGINE:-}" ]; then
  echo "No LaTeX engine found. Installing Tectonic..." >&2
  if command -v brew >/dev/null 2>&1; then
    brew install tectonic
  else
    echo "ERROR: Homebrew not found, cannot auto-install Tectonic." >&2
    echo "Install an engine first, e.g.: brew install tectonic" >&2
    exit 1
  fi
  ENGINE="tectonic"
fi

echo "Using engine: $ENGINE" >&2
cd "$OUT_DIR"

case "$ENGINE" in
  tectonic) tectonic "$TEX_BASE" ;;
  latexmk)  latexmk -pdf -interaction=nonstopmode -halt-on-error "$TEX_BASE" ;;
  # Two passes so references/lengths settle.
  xelatex)  xelatex  -interaction=nonstopmode -halt-on-error "$TEX_BASE" && xelatex  -interaction=nonstopmode -halt-on-error "$TEX_BASE" ;;
  pdflatex) pdflatex -interaction=nonstopmode -halt-on-error "$TEX_BASE" && pdflatex -interaction=nonstopmode -halt-on-error "$TEX_BASE" ;;
esac

if [ -f "$OUT_DIR/$PDF_BASE" ]; then
  echo "PDF built: $OUT_DIR/$PDF_BASE" >&2
else
  echo "ERROR: compilation finished but $PDF_BASE was not produced. Check the LaTeX log." >&2
  exit 1
fi
