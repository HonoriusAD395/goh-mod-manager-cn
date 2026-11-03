# GoH Mod Manager - Chinese Edition

*A modern mod manager for [Call to Arms: Gates of Hell](https://www.barbed-wire.eu/we-are-barbedwire-studios/our-game-development/), built with PySide6.*

This is a derivative work based on [alexbdka/goh-mod-manager](https://github.com/alexbdka/goh-mod-manager) (v1.4.2), adding a Chinese UI, per-mod aliases, and broader text-encoding support.

> **🤖 AI Disclosure**
> Parts of this project's code and documentation were produced with AI assistance and
> reviewed by a human. AI-generated or AI-modified code is marked with
> `# AI-generated: [description]`. See [AI_DISCLOSURE.md](AI_DISCLOSURE.md) for details.

---

## Features

### Added on top of upstream

- **Chinese UI**: main window, dialogs and preferences are translated; the language can be switched in Preferences and is auto-detected on Chinese systems
- **Per-mod aliases**: right-click a mod to set a custom alias; the list shows `Alias | Mod Name` and search matches either field
- **Encoding tolerance**: `mod.info` is read as UTF-8, UTF-8 with BOM, GBK, GB2312, GB18030 or CP936, which fixes garbled Chinese text
- **Mod source indicator**: 🎮 for Steam Workshop mods, 📦 for local mods, with details on hover
- **Local mod support**: local mods are written to `options.set` using their folder name
- **External language packs**: an `i18n/` folder next to the executable takes priority, so translations can be edited or added without rebuilding

### Inherited from upstream

- Mod install / uninstall and enable / disable
- Mod dependency detection
- Preset management (save / load configurations)
- Configuration share-code export / import
- Mod detail view

---

## Requirements

- Python **3.12**
- [uv](https://docs.astral.sh/uv/) (recommended) or pip

---

## Installation

```bash
git clone https://github.com/HonoriusAD395/goh-mod-manager-cn.git
cd goh-mod-manager-cn
uv sync
```

Without uv:

```bash
python -m pip install pyside6 loguru packaging requests py7zr rarfile vdf
```

---

## Usage

```bash
uv run -m goh_mod_manager
```

On first launch, check the game directory, mods directory and `options.set` path in Preferences.

---

## Building

### 1. Compile translations (optional)

```bash
# Windows
scripts\qt\compile_translations.ps1

# Linux
for f in goh_mod_manager/i18n/*.ts; do uv run pyside6-lrelease "$f"; done
```

### 2. Package

**Windows**

```bash
uv run pyinstaller ^
            --onefile ^
            --clean ^
            --windowed ^
            --name "goh_mod_manager" ^
            --icon "goh_mod_manager\res\icon\logo.ico" ^
            --add-data "goh_mod_manager\i18n\*.qm;goh_mod_manager\i18n" ^
            goh_mod_manager\__main__.py
```

**Linux**

```bash
uv run pyinstaller \
            --onefile \
            --clean \
            --windowed \
            --name "goh_mod_manager" \
            --icon "goh_mod_manager/res/icon/logo.png" \
            --add-data "goh_mod_manager/i18n/*.qm:goh_mod_manager/i18n" \
            goh_mod_manager/__main__.py
```

The build lands in `dist/`. To let users edit translations, copy `goh_mod_manager/i18n/*.qm` into an `i18n/` folder next to the executable:

```
dist/
├── goh_mod_manager(.exe)
└── i18n/
    └── goh_mod_manager_zh_CN.qm
```

> The application reads `i18n/` next to the executable first, then falls back to the language pack bundled inside the binary.

Pushing a `v*` tag makes GitHub Actions build release archives for Windows and Linux, see [.github/workflows/build.yml](.github/workflows/build.yml).

---

## Documentation

| Document | Contents |
|---|---|
| [AI_DISCLOSURE.md](AI_DISCLOSURE.md) | Where AI was used and how the result was verified |
| [MOD_INFO_READING.md](MOD_INFO_READING.md) | Where `mod.info` is read from and how it is parsed |
| [OPTIONS_SET_FORMAT.md](OPTIONS_SET_FORMAT.md) | The two formats used for mod entries in `options.set` |
| [MOD_SOURCE_INDICATOR.md](MOD_SOURCE_INDICATOR.md) | How the mod source indicator works |
| [WORKFLOW.md](WORKFLOW.md) | Architecture and key flows |
| [STARTUP_GUIDE.md](STARTUP_GUIDE.md) | Running and troubleshooting |
| [goh_mod_manager/i18n/README.md](goh_mod_manager/i18n/README.md) | Translation file naming and how to contribute |

---

## Credits

- Original project: [alexbdka/goh-mod-manager](https://github.com/alexbdka/goh-mod-manager)
- Earlier prototype: [Elaindil (MrCookie)/ModManager](https://github.com/Elaindil/ModManager)
- Logo design: [awasde](https://www.linkedin.com/in/am%C3%A9lie-rakowiecki-970818350)
- Fonts: [Inter](https://github.com/rsms/inter) and [OpenDyslexic](https://github.com/antijingoist/opendyslexic), both under the SIL Open Font License 1.1; full text in [goh_mod_manager/res/font/OFL.txt](goh_mod_manager/res/font/OFL.txt)

---

## License

Released under the **MIT License**; see [LICENSE](LICENSE).

The upstream project is also MIT licensed, `Copyright (c) 2026 alexbdka`, and that notice is preserved in [LICENSE](LICENSE).

---

## Contact

Pull requests are welcome. Please check whether the repository's Issues tab is enabled before opening an issue.

**Author**: HonoriusAD395
**GitHub**: <https://github.com/HonoriusAD395/goh-mod-manager-cn>
