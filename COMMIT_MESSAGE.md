feat: Add automatic geo files management with docker-compose.yml patching

🌍 New Feature: Geo Files Management Module

Added comprehensive geo files management system for Remnanode with automatic
docker-compose.yml patching capability.

## What's New

### Core Features
- 🔧 Automatic docker-compose.yml volumes patching
- 🌍 Geo files auto-update from runetfreedom repository
- 📦 Support for multiple nodes (remnanode, remnanode2, remnanode3)
- 🔄 Weekly automatic updates via cron
- 💾 Backup creation before any configuration changes
- 📋 Comprehensive logging system

### Key Components Added
- `scripts/remnanode/install-geo.sh` - Main geo files management script
- `scripts/common/languages-geo-addon.sh` - Localization strings (RU/EN)
- Modified `remnasetup.sh` - Added new menu item in Remnanode section
- `apply-geo-patch.sh` - Automatic installation script

### Technical Details
The script automatically:
1. Checks docker-compose.yml for geo volumes
2. Creates backup before modifications
3. Adds missing volumes configuration:
   ```yaml
   volumes:
     - ./geoip.dat:/usr/local/share/xray/geoip.dat
     - ./geosite.dat:/usr/local/share/xray/geosite.dat
   ```
4. Downloads latest geo files from runetfreedom
5. Recreates containers with new configuration

### Menu Structure
```
Main Menu
  └─► 2. Remnanode Installation/Update
       └─► 8. 🌍 Geo Files Management (NEW!)
            ├─► 1. Install/Update geo files
            ├─► 2. Configure automatic updates
            ├─► 3. Run manual update
            ├─► 4. Show update log
            ├─► 5. Show cron schedule
            └─► 6. Remove automatic updates
```

## Documentation
- 📄 README-GEO.md - Full documentation
- 📄 QUICKSTART.md - Quick installation guide
- 📄 CHANGELOG-VOLUMES.md - Detailed patching explanation
- 📄 VISUAL-GUIDE.txt - Visual workflow diagrams
- 📄 INDEX.md - Complete project overview
- 📄 MENU-STRUCTURE.txt - Menu visualization

## Security
- ✅ Automatic backups before changes
- ✅ Smart detection of existing volumes
- ✅ Safe rollback capability
- ✅ Temporary directory for downloads
- ✅ Comprehensive error handling

## Sources
- Geo files: github.com/runetfreedom/russia-v2ray-rules-dat
- Original RemnaSetup: github.com/Capybara-z/RemnaSetup

## Breaking Changes
None. Fully backward compatible with existing RemnaSetup installations.

## Installation
```bash
# Download and apply patch
tar -xzf remnasetup-geo-mod.tar.gz
cd remnasetup-modified
sudo bash apply-geo-patch.sh
```

## Testing
Tested on:
- Ubuntu 20.04/22.04/24.04
- Debian 11/12
- Docker Compose v2.x

## Version
RemnaSetup v2.6 with Geo Files Management

---

Co-authored-by: RemnaSetup <@KaTTuBaRa>
Co-authored-by: runetfreedom geo databases
