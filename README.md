# RemnaSetup v2.6 - Enhanced Edition 🌍

<div align="center">

![RemnaSetup](https://img.shields.io/badge/RemnaSetup-2.6-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Ubuntu%20%7C%20Debian-orange)
![Geo Files](https://img.shields.io/badge/Geo_Files-Auto_Update-brightgreen)

**Universal script for automatic installation, configuration, and updating of Remnawave and Remnanode infrastructure**

**Enhanced with automatic Geo Files Management and Docker Compose patching**

[![GitHub](https://img.shields.io/badge/GitHub-1nFern0--git-181717?logo=github)](https://github.com/1nFern0-git/RemnaSetup)
[![Based on](https://img.shields.io/badge/Based_on-Capybara--z%2FRemnaSetup-blue)](https://github.com/Capybara-z/RemnaSetup)

</div>

---

## 🚀 Quick Installation

### Option 1: One-Line Installation (Recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)
```

### Option 2: Download and Run

```bash
curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh -o install.sh
chmod +x install.sh
sudo bash install.sh
```

### Option 3: Clone Repository

```bash
git clone -b dev https://github.com/1nFern0-git/RemnaSetup.git
cd RemnaSetup
sudo bash install.sh
```

---

## ✨ What's New in v2.6?

### 🌍 Geo Files Management Module

A complete solution for managing geographic database files for Remnanode installations.

**Key Features:**
- ✅ **Automatic docker-compose.yml patching** - No manual editing required
- ✅ **Smart volume detection** - Only patches when needed
- ✅ **Multi-node support** - Works with remnanode, remnanode2, remnanode3
- ✅ **Weekly auto-updates** - Configurable cron scheduling
- ✅ **Backup system** - Creates backups before any changes
- ✅ **Comprehensive logging** - All operations logged to file
- ✅ **Bilingual** - Full Russian and English support

**Access:**
```
RemnaSetup → 2. Remnanode → 8. 🌍 Geo Files Management
```

---

## 🔥 Core Features

<table>
<tr>
<td width="50%" align="center">

### 🎯 Remnawave
- Installation and configuration of control panel
- Installation of subscription page
- Integration with Caddy for request proxying
- Protection of panel and subscriptions
- Automatic component updates

</td>
<td width="50%" align="center">

### 🌐 Remnanode
- Installation and configuration of node
- Integration with Caddy for self-steal
- Network optimization through BBR
- WARP-NATIVE (by distillium) integration
- **🌍 Geo Files Management (NEW!)**
- Automatic component updates

</td>
</tr>
</table>

---

## 📋 Menu Structure

```
Main Menu
├── 1. Remnawave Installation/Update
│   ├── Full installation (Remnawave + Subscription Page + Caddy)
│   ├── Install Remnawave
│   ├── Install Subscription Page
│   ├── Install Caddy
│   ├── Update (Remnawave + Subscription Page)
│   ├── Update Remnawave
│   └── Update Subscription Page
│
├── 2. Remnanode Installation/Update
│   ├── Full installation (Remnanode + Caddy + BBR + WARP)
│   ├── Install Remnanode only
│   ├── Install Caddy + self-steal
│   ├── IPv6 Management
│   ├── Install BBR only
│   ├── Install WARP-NATIVE
│   ├── Update Remnanode
│   └── 🌍 Geo Files Management ⭐ NEW!
│       ├── Install/Update geo files
│       ├── Configure automatic updates
│       ├── Run manual update
│       ├── Show update log
│       ├── Show cron schedule
│       └── Remove automatic updates
│
└── 3. Remnawave Backup and Restore
    ├── Create Remnawave backup
    ├── Restore from Remnawave backup
    └── Configure automatic backup
```

---

## 🌍 Geo Files Management Details

### What it does

Automatically manages geographic database files (geoip.dat, geosite.dat) for Remnanode:

1. **Checks docker-compose.yml** for volumes configuration
2. **Creates backup** before any changes
3. **Adds volumes** if missing:
   ```yaml
   volumes:
     - ./geoip.dat:/usr/local/share/xray/geoip.dat
     - ./geosite.dat:/usr/local/share/xray/geosite.dat
   ```
4. **Downloads latest files** from [runetfreedom/russia-v2ray-rules-dat](https://github.com/runetfreedom/russia-v2ray-rules-dat)
5. **Recreates containers** with new configuration

### How to use

```bash
# Run RemnaSetup
sudo bash /opt/remnasetup/remnasetup.sh

# Navigate to: 2 → 8 → Choose action
```

**Quick actions:**
- Option 1: Install geo files (first time)
- Option 2: Setup automatic weekly updates
- Option 3: Manual update anytime

### Files created

```
/usr/local/bin/update-remnanode-geo.sh     - Update script
/var/log/remnanode-geo-update.log          - Operation logs
/opt/remnanode/docker-compose.yml.backup-* - Config backups
```

---

## 📚 Documentation

- **[Full Geo Files Documentation](README-GEO.md)** - Complete feature guide
- **[Quick Start Guide](QUICKSTART.md)** - Fast installation
- **[Visual Guide](VISUAL-GUIDE.txt)** - Workflow diagrams
- **[Changelog](CHANGELOG-VOLUMES.md)** - Docker patching details
- **[Menu Structure](MENU-STRUCTURE.txt)** - Complete menu tree

---

## 💻 System Requirements

- **OS:** Ubuntu 20.04+ or Debian 10+
- **RAM:** Minimum 1GB (recommended 2GB+)
- **Disk:** Minimum 10GB free space
- **Network:** Internet connection required
- **Privileges:** Root access

---

## 🔧 Technical Details

### Created Files
```
/opt/remnasetup/                           - Main directory
├── remnasetup.sh                          - Main script
├── scripts/remnanode/install-geo.sh       - Geo management module
├── scripts/common/languages-geo-addon.sh  - Translations
└── ...

/usr/local/bin/update-remnanode-geo.sh     - Geo update script
/var/log/remnanode-geo-update.log          - Update logs
```

### Modified Files
```
/opt/remnanode/docker-compose.yml          - Patched with volumes
/opt/remnanode2/docker-compose.yml         - Patched with volumes
/opt/remnanode3/docker-compose.yml         - Patched with volumes
```

### Cron Job
```
0 3 * * 0 /usr/local/bin/update-remnanode-geo.sh
```
*(Every Sunday at 3:00 AM - configurable)*

---

## 🛡️ Security Features

### Automatic Backups
Every modification creates a timestamped backup:
```
/opt/remnanode/docker-compose.yml.backup-20250115-030001
```

### Smart Detection
- Checks for existing volumes before patching
- Only modifies when necessary
- Validates configuration before applying

### Safe Rollback
```bash
# Restore from backup
sudo cp /opt/remnanode/docker-compose.yml.backup-* \
        /opt/remnanode/docker-compose.yml
cd /opt/remnanode
sudo docker compose down && sudo docker compose up -d
```

---

## 🔍 Verification

```bash
# Check installation
ls -la /opt/remnasetup/scripts/remnanode/install-geo.sh

# Verify docker-compose.yml patching
cat /opt/remnanode/docker-compose.yml | grep -A2 "volumes:"

# Check cron job
crontab -l | grep geo

# View logs
tail -f /var/log/remnanode-geo-update.log

# Check geo files
ls -lh /opt/remnanode/geo*.dat
```

---

## ❓ FAQ

**Q: How often are geo files updated?**
A: By default, weekly (Sunday 3:00 AM). Configurable through the menu.

**Q: Will my docker-compose.yml be modified?**
A: Yes, but only if volumes are missing. Backup is created automatically.

**Q: Will containers restart?**
A: Yes, containers are recreated on first setup, then only restarted on updates.

**Q: Can I use this with the original RemnaSetup?**
A: Yes! This is fully compatible and can be applied as a patch.

**Q: What if I don't want automatic updates?**
A: Use menu option "Remove automatic updates" to disable cron.

---

## 🐛 Troubleshooting

### Geo files not updating
```bash
# Check GitHub access
curl -I https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geoip.dat

# Check script
ls -la /usr/local/bin/update-remnanode-geo.sh

# Run manually with debug
sudo bash -x /usr/local/bin/update-remnanode-geo.sh
```

### Cron not working
```bash
# Check cron service
sudo systemctl status cron

# Restart cron
sudo systemctl restart cron

# Verify cron job
crontab -l | grep geo
```

---

## 🙏 Credits

### Original Projects
- **RemnaSetup:** [@KaTTuBaRa](https://t.me/KaTTuBaRa) - [GitHub](https://github.com/Capybara-z/RemnaSetup)
- **Geo Databases:** [runetfreedom](https://github.com/runetfreedom/russia-v2ray-rules-dat)
- **WARP-NATIVE:** [distillium](https://github.com/distillium)

### Support
- **GitHub SoloBot:** https://github.com/Vladless/Solo_bot
- **Telegram:** @solonet_sup

---

## 📄 License

MIT License

Copyright (c) 2024

Based on [RemnaSetup](https://github.com/Capybara-z/RemnaSetup) by Capybara

---

## 🔗 Links

- **This Repository:** https://github.com/1nFern0-git/RemnaSetup/tree/dev
- **Original RemnaSetup:** https://github.com/Capybara-z/RemnaSetup
- **Geo Files Source:** https://github.com/runetfreedom/russia-v2ray-rules-dat

---

<div align="center">

### 🌟 If you find this useful, please star the repository! 🌟

**RemnaSetup Enhanced Edition** — Your universal assistant for Remnawave and RemnaNode with automatic Geo Files Management! 🚀

</div>
