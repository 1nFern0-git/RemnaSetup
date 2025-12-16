# 📦 Installation Commands for RemnaSetup v2.6

## 🚀 Quick Installation Commands

### ✨ Recommended: One-Line Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)
```

**Why this is best:**
- ✅ Fastest installation
- ✅ Always gets latest version from dev branch
- ✅ No temporary files left
- ✅ Automatic cleanup

---

## 📋 All Installation Methods

### Method 1: Direct Execution (Recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)
```

### Method 2: Download and Execute

```bash
# Download install script
curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh -o install.sh

# Make executable
chmod +x install.sh

# Run
sudo bash install.sh
```

### Method 3: Download with wget

```bash
# Download install script
wget -O install.sh https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh

# Make executable
chmod +x install.sh

# Run
sudo bash install.sh
```

### Method 4: Clone Full Repository

```bash
# Clone repository (dev branch)
git clone -b dev https://github.com/1nFern0-git/RemnaSetup.git

# Navigate to directory
cd RemnaSetup

# Run installation
sudo bash install.sh
```

### Method 5: Download as ZIP

```bash
# Download repository as ZIP
curl -L https://github.com/1nFern0-git/RemnaSetup/archive/refs/heads/dev.zip -o remnasetup.zip

# Extract
unzip remnasetup.zip

# Navigate
cd RemnaSetup-dev

# Run
sudo bash install.sh
```

---

## 🎯 Installation for Specific Components

### Only Geo Files Patch (for existing RemnaSetup)

```bash
# Download patch script
curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/apply-geo-patch.sh -o apply-geo-patch.sh

# Make executable
chmod +x apply-geo-patch.sh

# Apply patch
sudo bash apply-geo-patch.sh
```

### Fresh Install with Geo Files

```bash
# One command - full installation
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)

# Then access: RemnaSetup → Remnanode → Geo Files Management
```

---

## 🌐 URLs Reference

### Raw File URLs (for scripts)

```bash
# Main install script
https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh

# Geo patch script
https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/apply-geo-patch.sh

# Main script
https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/remnasetup.sh

# Geo management script
https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/scripts/remnanode/install-geo.sh
```

### Repository URLs

```bash
# HTTPS Clone
https://github.com/1nFern0-git/RemnaSetup.git

# SSH Clone
git@github.com:1nFern0-git/RemnaSetup.git

# ZIP Download
https://github.com/1nFern0-git/RemnaSetup/archive/refs/heads/dev.zip

# Web View
https://github.com/1nFern0-git/RemnaSetup/tree/dev
```

---

## 🔄 Update Existing Installation

### Update to Latest Version

```bash
# Navigate to installation directory
cd /opt/remnasetup

# Backup current version
sudo cp -r /opt/remnasetup /opt/remnasetup.backup-$(date +%Y%m%d)

# Download latest version
sudo rm -rf /opt/remnasetup
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)
```

### Update Only Geo Module

```bash
# Download latest geo script
sudo curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/scripts/remnanode/install-geo.sh \
     -o /opt/remnasetup/scripts/remnanode/install-geo.sh

# Make executable
sudo chmod +x /opt/remnasetup/scripts/remnanode/install-geo.sh
```

---

## 📱 Copy-Paste Ready Commands

### For README.md

```markdown
## Installation

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)
```
```

### For Telegram/Discord

```
🚀 RemnaSetup v2.6 Installation:

bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)

Features:
• Automatic Geo Files Management
• Docker Compose patching
• Multi-node support

Docs: https://github.com/1nFern0-git/RemnaSetup/tree/dev
```

### For Documentation

```bash
# Quick Install
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)

# Or download and run
curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh -o install.sh
chmod +x install.sh
sudo bash install.sh
```

---

## 🛠️ Advanced Options

### Install to Custom Directory

```bash
# Clone repository
git clone -b dev https://github.com/1nFern0-git/RemnaSetup.git /custom/path

# Modify install.sh to use custom path
# Then run
sudo bash /custom/path/install.sh
```

### Silent Install (No Interactive Prompts)

```bash
# Not recommended, but possible
# Run with predefined answers
sudo bash install.sh < /dev/null
```

### Install with Logging

```bash
# Log installation process
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh) 2>&1 | tee install.log
```

---

## 🔍 Verification Commands

### After Installation

```bash
# Verify installation directory
ls -la /opt/remnasetup/

# Check main script
ls -la /opt/remnasetup/remnasetup.sh

# Verify geo module
ls -la /opt/remnasetup/scripts/remnanode/install-geo.sh

# Test run (will show menu)
sudo bash /opt/remnasetup/remnasetup.sh
```

### Check Version

```bash
# View version info
cat /opt/remnasetup/remnasetup.sh | grep "Version:"

# Expected output: Version: 2.6
```

---

## 🐛 Troubleshooting Installation

### If curl is not installed

```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y curl

# CentOS/RHEL
sudo yum install -y curl

# Then retry installation
```

### If installation fails

```bash
# Check system requirements
cat /etc/os-release

# Check disk space
df -h

# Check internet connection
ping -c 3 github.com

# Try alternative method
git clone -b dev https://github.com/1nFern0-git/RemnaSetup.git
cd RemnaSetup
sudo bash install.sh
```

### Clean install (remove old version first)

```bash
# Backup if needed
sudo cp -r /opt/remnasetup /opt/remnasetup.backup

# Remove old version
sudo rm -rf /opt/remnasetup

# Fresh install
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)
```

---

## 📊 Installation Statistics

- **Install Time:** ~2-5 minutes (depending on connection)
- **Download Size:** ~50 KB (compressed)
- **Installed Size:** ~200 KB
- **Dependencies:** curl, unzip (auto-installed if missing)

---

## 🎓 For Developers

### Clone for Development

```bash
# Clone with full history
git clone -b dev https://github.com/1nFern0-git/RemnaSetup.git

# Clone shallow (faster)
git clone -b dev --depth 1 https://github.com/1nFern0-git/RemnaSetup.git

# Clone specific commit
git clone -b dev https://github.com/1nFern0-git/RemnaSetup.git
cd RemnaSetup
git checkout <commit-hash>
```

### Test Local Changes

```bash
# After making changes
sudo bash ./install.sh

# Or test individual scripts
sudo bash ./scripts/remnanode/install-geo.sh
```

---

## 📞 Support

If installation fails:
1. Check system requirements
2. Read troubleshooting section above
3. Open issue: https://github.com/1nFern0-git/RemnaSetup/issues
4. Contact: Original author [@KaTTuBaRa](https://t.me/KaTTuBaRa)

---

## 🔗 Quick Links

- **Repository:** https://github.com/1nFern0-git/RemnaSetup/tree/dev
- **Install Script:** https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh
- **Issues:** https://github.com/1nFern0-git/RemnaSetup/issues
- **Original Project:** https://github.com/Capybara-z/RemnaSetup

---

**Last Updated:** December 2024
**Version:** 2.6
**Status:** Stable
