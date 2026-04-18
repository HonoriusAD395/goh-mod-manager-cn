# GoH Mod Manager - HA Edition

*A modern mod manager
for [Call to Arms: Gates of Hell](https://www.barbed-wire.eu/we-are-barbedwire-studios/our-game-development/), built
with PySide6.*

A user-friendly graphical interface for managing mods, presets, configuration sharing, and more.

**This is a forked enhanced version with additional features including Chinese support, mod alias system, and multi-encoding support.**

---

## 🆕 New Features (v1.4.2 HA Edition)

### ✨ Mod Alias System
- **Right-click to set alias**: Right-click on a mod in the installed mods list to set a custom alias/note
- **Smart display format**: Aliases are displayed as `Alias | Mod Name` for quick identification
- **Enhanced search**: Search box supports searching by alias or mod name, matching either field will show results

### 🌐 Complete Chinese Encoding Support
- **Multi-encoding parsing**: Supports UTF-8, UTF-8 with BOM, GBK, GB2312, GB18030, CP936, and more
- **Smart encoding detection**: Automatically tries multiple encodings to ensure correct reading of Chinese mod.info files
- **Chinese display fix**: Fixed garbled text issues caused by incorrect `unicode_escape` decoding of UTF-8 Chinese content

### 🛠️ Technical Improvements
- Fixed `ModInfoParser` Chinese encoding parsing logic
- Enhanced `ModManagerView` text processing to protect UTF-8 Chinese characters
- Optimized search filter logic to support alias field retrieval
- Added configuration file persistent storage (based on QSettings)

---

## Requirements

- Python **3.12** or higher
- pip (Python package manager)

---

## Installation

1. Clone the repository:

```bash
git clone https://github.com/HonoriusAD395/goh-mod-manager-HA.git
cd goh-mod-manager-HA
```

2. Install dependencies:

```bash
python -m pip install pyside6 loguru packaging requests py7zr rarfile vdf
```

---

## Usage

Run the application:

```bash
python -m goh_mod_manager
```

---

## Features

### Core Features
- ✅ Mod installation/uninstallation management
- ✅ Mod enable/disable toggling
- ✅ Mod dependency detection
- ✅ Preset management (save/load configurations)
- ✅ Configuration share code export/import
- ✅ Mod detailed information viewing

### Enhanced Features (This Version)
- ✨ Mod alias notes (Chinese supported)
- ✨ Alias search functionality
- ✨ Complete Chinese mod.info support
- ✨ Right-click menu quick operations
- ✨ Automatic encoding detection

---

## Building

### Compile Translation Files (Optional)

```bash
# Windows
scripts\qt\compile_translations.ps1

# Linux
for f in goh_mod_manager/i18n/*.ts; do python -m pyside6-lrelease "$f"; done
```

**PyInstaller (Windows)**

```bash
python -m PyInstaller ^
            --onefile ^
            --clean ^
            --windowed ^
            --name "GoH_Mod_Manager_HA" ^
            --icon "goh_mod_manager\res\icon\logo.ico" ^
            goh_mod_manager\__main__.py
```

**PyInstaller (Linux)**

```bash
python -m PyInstaller \
            --onefile \
            --clean \
            --windowed \
            --name "GoH_Mod_Manager_HA" \
            --icon "goh_mod_manager/res/icon/logo.png" \
            goh_mod_manager/__main__.py
```

The compiled executable will be available in the `dist` directory.

---

## Dependencies

- **PySide6** - Qt for Python GUI framework
- **loguru** - Logging library
- **packaging** - Version comparison tool
- **requests** - HTTP request library
- **py7zr** - 7z compression support
- **rarfile** - RAR compression support
- **vdf** - Valve Data Format parser
- **PyInstaller** - Standalone executable builder (recommended for releases)

---

## Changelog

### v1.4.2 HA (HonoriusAD395 Enhanced Edition)
**New Features:**
- [NEW] Mod alias system
  - Added "Set Alias" and "Clear Alias" options in right-click menu
  - Supports Chinese alias input
  - List display format: `Alias | Mod Name`
- [NEW] Enhanced search
  - Search box supports alias field matching
  - Supports dual retrieval by alias and mod name
- [NEW] Complete Chinese encoding support
  - Added UTF-8-sig, GB18030, CP936 encoding support
  - Smart encoding detection, automatically identifies file encoding
  - Fixed Chinese mod.info garbled text issue

**Bug Fixes:**
- [FIX] Fixed `unicode_escape` decoding breaking UTF-8 Chinese in `parse_formatted_text` method
- [FIX] Fixed `_filter_list_widget` search not including alias field
- [FIX] Fixed incomplete encoding support in `ModInfoParser._load_file`

**Code Improvements:**
- [IMP] `core/mod.py` - Added `alias` field and optimized `__str__` method
- [IMP] `infrastructure/mod_info_parser.py` - Extended encoding support list
- [IMP] `infrastructure/config_manager.py` - Added alias storage methods
- [IMP] `presentation/controller/mod_manager_controller.py` - Added alias-related controllers
- [IMP] `presentation/view/mod_manager_view.py` - Optimized text processing logic

---

## Credits

- Logo design by [awasde](https://www.linkedin.com/in/amélie-rakowiecki-970818350)
- Original mod manager by [Elaindil (MrCookie)](https://github.com/Elaindil/ModManager)
- Original project author: [alexbdka](https://github.com/alexbdka)

---

## License

This project is a fork based on the original [alexbdka/goh-mod-manager](https://github.com/alexbdka/goh-mod-manager) and follows the original project license.

---

## Contact

For questions or suggestions, feel free to submit an Issue or Pull Request.

**Author**: HonoriusAD395  
**GitHub**: https://github.com/HonoriusAD395/goh-mod-manager-HA
