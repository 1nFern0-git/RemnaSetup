# RemnaSetup v2.6 - Geo Files Management 🌍

## 🎉 Major Feature Release

This release adds comprehensive **Geo Files Management** functionality to RemnaSetup with automatic `docker-compose.yml` patching.

---

## ✨ What's New

### 🌍 Geo Files Management Module

A complete solution for managing geographic database files (geoip.dat, geosite.dat) for Remnanode installations.

**Key Features:**
- ✅ **Automatic docker-compose.yml patching** - No manual editing required
- ✅ **Multi-node support** - Works with remnanode, remnanode2, remnanode3
- ✅ **Weekly auto-updates** - Configurable cron scheduling
- ✅ **Smart volume detection** - Only patches when needed
- ✅ **Backup system** - Creates backups before any changes
- ✅ **Comprehensive logging** - All operations logged to file
- ✅ **Bilingual** - Full Russian and English support

### 📍 New Menu Item

Access the new functionality:
```
RemnaSetup → 2. Remnanode → 8. 🌍 Geo Files Management
```

**Available Actions:**
1. Install/Update geo files (+ auto-patch docker-compose.yml)
2. Configure automatic updates
3. Run manual update
4. Show update log
5. Show cron schedule
6. Remove automatic updates

---

## 🔧 Technical Details

### Automatic Docker-Compose Patching

The script automatically adds these volumes to your `docker-compose.yml`:

```yaml
volumes:
  - ./geoip.dat:/usr/local/share/xray/geoip.dat
  - ./geosite.dat:/usr/local/share/xray/geosite.dat
```

**Process:**
1. ✓ Checks if volumes already exist
2. ✓ Creates backup: `docker-compose.yml.backup-YYYYMMDD-HHMMSS`
3. ✓ Adds volumes if missing
4. ✓ Downloads latest geo files from runetfreedom
5. ✓ Recreates containers with new configuration

### Geo Files Source

Files are downloaded from:
- **Repository:** [runetfreedom/russia-v2ray-rules-dat](https://github.com/runetfreedom/russia-v2ray-rules-dat)
- **Files:** geoip.dat, geosite.dat
- **Update frequency:** Weekly (customizable)

---

## 📦 Installation

### For Existing RemnaSetup

```bash
# Download the patch
wget https://github.com/your-repo/releases/download/v2.6/remnasetup-geo-mod.tar.gz

# Extract
tar -xzf remnasetup-geo-mod.tar.gz
cd remnasetup-modified

# Apply patch
sudo bash apply-geo-patch.sh
```

### Fresh Install

```bash
# Clone the modified repository
git clone https://github.com/your-repo/RemnaSetup-modified.git
cd RemnaSetup-modified

# Run installation
sudo bash install.sh
```

---

## 📚 Documentation

Comprehensive documentation included:

- **README-GEO.md** - Complete feature documentation
- **QUICKSTART.md** - Quick installation guide
- **CHANGELOG-VOLUMES.md** - Detailed patching explanation
- **VISUAL-GUIDE.txt** - Visual workflow diagrams
- **INDEX.md** - Full project overview
- **MENU-STRUCTURE.txt** - Interactive menu structure

---

## 🛡️ Safety Features

### Automatic Backups
Every docker-compose.yml modification creates a timestamped backup:
```
/opt/remnanode/docker-compose.yml.backup-20250115-030001
```

### Easy Rollback
```bash
# Restore from backup
sudo cp /opt/remnanode/docker-compose.yml.backup-* /opt/remnanode/docker-compose.yml
cd /opt/remnanode
sudo docker compose down && sudo docker compose up -d
```

### Smart Detection
- Script checks for existing volumes before patching
- Only modifies docker-compose.yml when necessary
- Skips patching if volumes already configured

---

## 📋 Files Changed

**New Files:**
```
/opt/remnasetup/scripts/remnanode/install-geo.sh
/opt/remnasetup/scripts/common/languages-geo-addon.sh
/usr/local/bin/update-remnanode-geo.sh (created by script)
/var/log/remnanode-geo-update.log (log file)
```

**Modified Files:**
```
/opt/remnasetup/remnasetup.sh (added menu item)
/opt/remnasetup/scripts/common/languages.sh (added translations)
/opt/remnanode/docker-compose.yml (patched volumes)
```

---

## 🎯 Use Cases

### Scenario 1: First Time Setup
1. Install RemnaSetup with this patch
2. Run: RemnaSetup → Remnanode → Geo Files Management
3. Choose: "Install/Update geo files"
4. Script automatically patches docker-compose.yml and installs files

### Scenario 2: Automatic Updates
1. Choose: "Configure automatic updates"
2. Script sets up weekly cron job
3. Geo files update automatically every Sunday at 3:00 AM
4. Containers restart with new files

### Scenario 3: Manual Update
1. Choose: "Run manual update"
2. Latest files downloaded immediately
3. All nodes updated
4. View results in log

---

## 🔍 Verification

Check if everything works:

```bash
# Verify script installation
ls -la /opt/remnasetup/scripts/remnanode/install-geo.sh

# Check docker-compose.yml patching
cat /opt/remnanode/docker-compose.yml | grep -A2 "volumes:"

# Verify cron job
crontab -l | grep geo

# View logs
tail -f /var/log/remnanode-geo-update.log

# Check geo files
ls -lh /opt/remnanode/geo*.dat
```

---

## 🐛 Known Issues

None at this time. Please report any issues on GitHub.

---

## 🙏 Credits

- **Original RemnaSetup:** [@KaTTuBaRa](https://t.me/KaTTuBaRa) - [GitHub](https://github.com/Capybara-z/RemnaSetup)
- **Geo Databases:** [runetfreedom](https://github.com/runetfreedom/russia-v2ray-rules-dat)
- **Docker Compose:** Docker Inc.

---

## 📄 License

MIT License (same as original RemnaSetup)

---

## 🔗 Links

- **Original Project:** https://github.com/Capybara-z/RemnaSetup
- **Geo Files Source:** https://github.com/runetfreedom/russia-v2ray-rules-dat
- **Telegram Support:** [@KaTTuBaRa](https://t.me/KaTTuBaRa)

---

## 📦 Downloads

### Full Package
- `remnasetup-geo-mod.tar.gz` (16 KB) - Complete modification package

### Individual Files
- `install-geo.sh` - Main geo files management script
- `apply-geo-patch.sh` - Automatic patch installer
- All documentation files included

---

## 🚀 What's Next?

Future improvements planned:
- [ ] Support for custom geo file sources
- [ ] Web UI for geo files management
- [ ] Advanced scheduling options
- [ ] Telegram notifications for updates
- [ ] Multiple geo file versions support

---

**Version:** 2.6  
**Release Date:** December 2024  
**Compatibility:** Ubuntu 20.04+, Debian 10+  
**Status:** Stable

---

⭐ If you find this useful, please star the original [RemnaSetup](https://github.com/Capybara-z/RemnaSetup) project!
