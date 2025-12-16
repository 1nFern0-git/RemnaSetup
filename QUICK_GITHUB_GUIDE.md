# 🚀 Quick GitHub Publication Guide

## One-Line Commands

```bash
# Prepare for publication
bash prepare-for-github.sh

# Initialize and push to GitHub
git init
git remote add origin https://github.com/YOUR-USERNAME/RemnaSetup-GeoMod.git
git add .
git commit -F .git-commit-msg.txt
git branch -M main
git push -u origin main

# Create release tag
git tag -a v2.6 -m "RemnaSetup v2.6 - Geo Files Management"
git push origin v2.6
```

## GitHub Release

1. Go to: `https://github.com/YOUR-USERNAME/RemnaSetup-GeoMod/releases/new`
2. **Tag:** `v2.6`
3. **Title:** `v2.6 - Geo Files Management 🌍`
4. **Description:** Copy from `RELEASE_NOTES.md`
5. **Attach:** `remnasetup-geomod-v2.6.tar.gz`
6. Click "Publish release"

## Done! 🎉

Your modification is now public on GitHub!

---

For detailed instructions, see `GITHUB_PUBLISH_GUIDE.md`
