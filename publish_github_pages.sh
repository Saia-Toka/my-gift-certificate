#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# Ensure the site folder has .nojekyll
mkdir -p site
touch site/.nojekyll

if [ ! -d .git ]; then
  echo "Initializing git repository..."
  git init
  git branch -M main
fi

git add .gitignore site/.nojekyll site
if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "Publish site to GitHub Pages"
fi

if ! git remote | grep -q '^origin$'; then
  echo "No origin remote found."
  echo "Create a GitHub repository and add it as origin, for example:"
  echo "  gh repo create USER/REPO --public --source=. --remote=origin --push"
  echo "Then run this script again."
  exit 1
fi

# Publish the site directory to gh-pages branch
if git show-ref --verify --quiet refs/heads/gh-pages; then
  git branch -D gh-pages
fi

git subtree split --prefix site -b gh-pages
git push -u origin gh-pages:gh-pages --force

echo "Published site/ to GitHub Pages branch gh-pages."