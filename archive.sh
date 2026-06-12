#!/bin/bash
# =============================================================
# archive.sh — Archive current wish before updating the page
# =============================================================
# Run this on the DigitalOcean server via SSH BEFORE you upload
# a new index.html for a different person/occasion.
#
# Usage:
#   chmod +x archive.sh          (first time only)
#   ./archive.sh firstname-year
#
# Example:
#   ./archive.sh nandita-2026
#   ./archive.sh ritika-2026
#   ./archive.sh mum-anniversary-2026
#
# What it does:
#   1. Copies current index.html → /archive/<slug>/index.html
#   2. Reminds you to add the entry to archive/index.html
#
# The photo (wishespicture.jpg) is NOT archived — the HTML alone
# preserves all the words and messages.
# =============================================================

SLUG="$1"
WEBROOT="/var/www/wishes"
SRC="$WEBROOT/index.html"
DEST="$WEBROOT/archive/$SLUG"

if [ -z "$SLUG" ]; then
  echo "❌  Usage: ./archive.sh <slug>"
  echo "    Example: ./archive.sh nandita-2026"
  exit 1
fi

if [ ! -f "$SRC" ]; then
  echo "❌  Could not find $SRC"
  exit 1
fi

if [ -d "$DEST" ]; then
  echo "⚠️   Archive '$SLUG' already exists at $DEST"
  echo "    Overwrite? (y/N)"
  read -r confirm
  if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Aborted."
    exit 0
  fi
fi

mkdir -p "$DEST"
cp "$SRC" "$DEST/index.html"

echo ""
echo "✅  Archived → $DEST/index.html"
echo ""
echo "Next steps:"
echo "  1. Upload the new index.html and wishespicture.jpg to $WEBROOT/"
echo "  2. Open $WEBROOT/archive/index.html and add this entry:"
echo ""
echo "    <li>"
echo "      <a href=\"/archive/$SLUG/\">"
echo "        <div class=\"wish-meta\">"
echo "          <span class=\"wish-name\">$(echo "$SLUG" | sed 's/-[0-9]*$//' | sed 's/\b./\u&/g')</span>"
echo "          <span class=\"wish-detail\">Occasion &nbsp;·&nbsp; Month Year</span>"
echo "        </div>"
echo "        <span class=\"wish-arrow\">&rsaquo;</span>"
echo "      </a>"
echo "    </li>"
echo ""
