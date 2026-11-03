# Translation sources (.ts) and compiled Qt binaries (.qm) live here.

## Naming

Files are named `goh_mod_manager_<locale>.ts` / `.qm`, where `<locale>` is a Qt locale
code such as `zh_CN`, `pt_BR`, `fr` or `de`. The part after the underscore is matched
case-insensitively by `goh_mod_manager/i18n/translator.py`.

## Currently shipped

| Locale | Source | Compiled |
|---|---|---|
| `en` | — (source language) | — |
| `zh_CN` | `goh_mod_manager_zh_CN.ts` | `goh_mod_manager_zh_CN.qm` |

English is the source language, so it needs **no** translation file: the strings in the
code are already English and `TranslationManager` always offers `en`.

Chinese coverage currently spans the UI files (main window, dialogs, preferences).
Strings emitted from controllers and view models (`self.tr(...)` inside `.py`) are not
translated yet — contributions welcome.

## Workflow

1) Generate or update a translation source file:

   - Create a new language file:
     `.\scripts\qt\update_translations.ps1 -Language fr`
   - Update all existing `.ts` files in this folder:
     `.\scripts\qt\update_translations.ps1`

2) Translate with Qt Linguist:
   `pyside6-linguist goh_mod_manager/i18n/goh_mod_manager_fr.ts`

3) Compile to a `.qm` binary for local testing:
   `pyside6-lrelease goh_mod_manager/i18n/goh_mod_manager_fr.ts`

4) Commit both the `.ts` source and the compiled `.qm`.

## Notes

- `goh_mod_manager_en.ts` / `.qm` were removed: the file had been mangled by a formatter
  (broken XML tags, source strings split mid-sentence) and the `.qm` was an empty stub.
  Regenerate it with `update_translations.ps1 -Language en` if you need a template.
- At runtime the application looks for `i18n/` next to the executable first, then falls
  back to the copy bundled into the binary.
- The CI build compiles `.qm` files from the committed `.ts` sources before packaging.
