# GoH Mod Manager - 中文增强版

*一个现代化的模组管理器，适用于 [Call to Arms: Gates of Hell](https://www.barbed-wire.eu/we-are-barbedwire-studios/our-game-development/)，基于 PySide6 开发。*

本项目是 [alexbdka/goh-mod-manager](https://github.com/alexbdka/goh-mod-manager)（v1.4.2）的二次开发版本，补充了中文界面、模组别名备注、多编码兼容等本地化工作。

> **🤖 AI 协作声明**
> 本项目的部分代码与文档在 AI 辅助下完成，并经过人工审阅与测试。
> AI 生成或修改的代码以 `# AI-generated: [说明]` 注释标注，完整说明见 [AI_DISCLOSURE.md](AI_DISCLOSURE.md)。

---

## 功能特性

### 在原版基础上新增

- **中文界面**：主窗口、各对话框、偏好设置已汉化，可在偏好设置中切换语言（中文系统会自动识别）
- **模组别名备注**：右键模组设置中文别名，列表显示为 `备注 | 模组名称`，搜索时按别名或原名任一匹配
- **多编码兼容**：读取 `mod.info` 时自动尝试 UTF-8、UTF-8 BOM、GBK、GB2312、GB18030、CP936，修复中文乱码
- **模组来源标识**：🎮 表示 Steam 创意工坊模组，📦 表示本地模组，鼠标悬停可查看详情
- **本地模组支持**：读取本地模组时使用其所在文件夹名写入 `options.set`
- **外部语言包**：程序优先读取 exe 同级目录下的 `i18n/` 文件夹，方便自行修改或增补翻译

### 原版已有功能

- 模组安装 / 卸载、启用 / 禁用
- 模组依赖检测
- 预设管理（保存 / 加载配置）
- 配置分享码导出 / 导入
- 模组详情查看

---

## 系统要求

- Python **3.12**
- [uv](https://docs.astral.sh/uv/)（推荐）或 pip

---

## 安装

```bash
git clone https://github.com/HonoriusAD395/goh-mod-manager-cn.git
cd goh-mod-manager-cn
uv sync
```

不想用 uv 的话：

```bash
python -m pip install pyside6 loguru packaging requests py7zr rarfile vdf
```

---

## 使用方法

```bash
uv run -m goh_mod_manager
```

首次启动后，在「偏好设置」中确认游戏目录、模组目录与 `options.set` 路径。

---

## 构建发布版

### 1. 编译翻译文件（可选）

```bash
# Windows
scripts\qt\compile_translations.ps1

# Linux
for f in goh_mod_manager/i18n/*.ts; do uv run pyside6-lrelease "$f"; done
```

### 2. 打包

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

产物在 `dist/` 中。若希望用户能自行修改翻译，把 `goh_mod_manager/i18n/*.qm` 复制到 exe 同级的 `i18n/` 目录：

```
dist/
├── goh_mod_manager(.exe)
└── i18n/
    └── goh_mod_manager_zh_CN.qm
```

> 程序会优先读取 exe 同级 `i18n/` 目录，读不到时再使用打包进二进制的语言包。

推送 `v*` 形式的 tag 时，GitHub Actions 会自动构建 Windows / Linux 两个平台的发布包，见 [.github/workflows/build.yml](.github/workflows/build.yml)。

---

## 文档

| 文档 | 内容 |
|---|---|
| [AI_DISCLOSURE.md](AI_DISCLOSURE.md) | AI 使用范围与人工验证方式 |
| [MOD_INFO_READING.md](MOD_INFO_READING.md) | `mod.info` 的读取位置与解析规则 |
| [OPTIONS_SET_FORMAT.md](OPTIONS_SET_FORMAT.md) | `options.set` 中模组条目的两种写入格式 |
| [MOD_SOURCE_INDICATOR.md](MOD_SOURCE_INDICATOR.md) | 模组来源标识的实现说明 |
| [WORKFLOW.md](WORKFLOW.md) | 代码架构与关键流程 |
| [STARTUP_GUIDE.md](STARTUP_GUIDE.md) | 启动与排障 |
| [goh_mod_manager/i18n/README.md](goh_mod_manager/i18n/README.md) | 翻译文件命名与贡献方式 |

---

## 致谢

- 原项目：[alexbdka/goh-mod-manager](https://github.com/alexbdka/goh-mod-manager)
- 更早的原型：[Elaindil (MrCookie)/ModManager](https://github.com/Elaindil/ModManager)
- Logo 设计：[awasde](https://www.linkedin.com/in/am%C3%A9lie-rakowiecki-970818350)
- 字体：[Inter](https://github.com/rsms/inter)、[OpenDyslexic](https://github.com/antijingoist/opendyslexic)，均为 SIL Open Font License 1.1，许可全文见 [goh_mod_manager/res/font/OFL.txt](goh_mod_manager/res/font/OFL.txt)

---

## 许可证

本项目以 **MIT License** 发布，完整文本见 [LICENSE](LICENSE)。

原项目同样使用 MIT License，`Copyright (c) 2026 alexbdka`；本衍生版本的原版权声明已保留在 [LICENSE](LICENSE) 中。

---

## 联系方式

欢迎提交 Issue 或 Pull Request。提问前建议先看上面「文档」一节的说明。

**作者**：HonoriusAD395（独轮车）
**GitHub**：<https://github.com/HonoriusAD395/goh-mod-manager-cn>
