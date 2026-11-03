# AI 标记清单 / AI Annotation Index

本文件登记当前仓库中带有 AI 协作标记的文件，以及它们改了什么。
总体说明、标注规则与验证方式见 [AI_DISCLOSURE.md](AI_DISCLOSURE.md)。

*This file indexes the files carrying AI-assistance markers. See
[AI_DISCLOSURE.md](AI_DISCLOSURE.md) for scope, conventions and verification.*

> 维护提示：新增或修改 AI 协作代码时，请同步更新本清单。
> *Keep this index in sync when AI-assisted code is added or changed.*

---

## 文件级标记 / File-level markers

以下文件首行带有 `# AI-generated code, human reviewed`：

| 文件 | 改动 |
|---|---|
| [goh_mod_manager/core/mod.py](goh_mod_manager/core/mod.py) | 新增 `alias` 字段；`__str__` 支持 `备注 \| 模组名称` 格式 |
| [goh_mod_manager/core/mod_manager_model.py](goh_mod_manager/core/mod_manager_model.py) | 加载模组时套用别名；新增 `replace_installed_mods()` |
| [goh_mod_manager/infrastructure/config_manager.py](goh_mod_manager/infrastructure/config_manager.py) | 别名读写改为 JSON 文件（`%APPDATA%\alex6\GoH Mod Manager\aliases.json`），支持 `ensure_ascii=False` |
| [goh_mod_manager/infrastructure/mod_info_parser.py](goh_mod_manager/infrastructure/mod_info_parser.py) | `_load_file()` 多编码回退（UTF-8 / UTF-8-BOM / GBK / GB2312 / GB18030 / CP936 / Latin-1） |
| [goh_mod_manager/infrastructure/options_set_parser.py](goh_mod_manager/infrastructure/options_set_parser.py) | 按模组来源区分 `options.set` 写入格式 |
| [goh_mod_manager/presentation/controller/mod_manager_controller.py](goh_mod_manager/presentation/controller/mod_manager_controller.py) | 右键菜单「设置别名 / 清除别名」；搜索支持别名 |
| [goh_mod_manager/presentation/view/mod_manager_view.py](goh_mod_manager/presentation/view/mod_manager_view.py) | 保护 UTF-8 中文不被 `unicode_escape` 破坏；来源图标与提示 |

## 无文件头但含 AI 改动 / Files changed without a file header

| 文件 | 改动 |
|---|---|
| [goh_mod_manager/__main__.py](goh_mod_manager/__main__.py) | `_get_translations_dir()`：打包后优先读 exe 同级 `i18n/` |
| [goh_mod_manager/i18n/translator.py](goh_mod_manager/i18n/translator.py) | 语言代码归一化与 `.qm` 回退查找 |
| [goh_mod_manager/res/ui/main_window.ui](goh_mod_manager/res/ui/main_window.ui) | 清理合并冲突残留，保留单一 `centralwidget` |

## 文档 / Documentation

| 文件 | 说明 |
|---|---|
| [AI_DISCLOSURE.md](AI_DISCLOSURE.md) | AI 使用范围、标注规则、人工验证与已知局限（AI 起草） |
| [README.md](README.md) / [README_en.md](README_en.md) | 功能与构建说明（AI 起草，人工校对） |
| [MOD_INFO_READING.md](MOD_INFO_READING.md) | `mod.info` 读取位置说明 |
| [OPTIONS_SET_FORMAT.md](OPTIONS_SET_FORMAT.md) | `options.set` 格式说明 |
| [MOD_SOURCE_INDICATOR.md](MOD_SOURCE_INDICATOR.md) | 来源标识说明 |
| [WORKFLOW.md](WORKFLOW.md) | 架构与流程说明 |
| [STARTUP_GUIDE.md](STARTUP_GUIDE.md) | 启动排障 |
| [BUG_FIX_20260415.md](BUG_FIX_20260415.md) | 2026-04-15 修复报告 |
| [BUGFIX_DOUBLE_CLICK_SCROLL_20260415.md](BUGFIX_DOUBLE_CLICK_SCROLL_20260415.md) | 双击滚动修复报告 |
| [BUILD_SUMMARY_20260416.md](BUILD_SUMMARY_20260416.md) | 打包记录 |
| [CHANGES_SUMMARY.md](CHANGES_SUMMARY.md) | 变更摘要 |
| [RELEASE_NOTES_v1.0.md](RELEASE_NOTES_v1.0.md) | v1.0 发布说明 |

---

## 版本信息 / Version

- 上游基座：GoH Mod Manager v1.4.2（[alexbdka/goh-mod-manager](https://github.com/alexbdka/goh-mod-manager)）
- 本仓库：`goh-mod-manager-cn`
- 最后更新：2026-11-03
