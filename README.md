# GoH Mod Manager - 修改版

*一个现代化的模组管理器，适用于 [Call to Arms: Gates of Hell](https://www.barbed-wire.eu/we-are-barbedwire-studios/our-game-development/)，基于 PySide6 开发。*

友好的图形界面，用于管理模组、预设、配置分享等功能。

**本版本为二次开发增强版，新增中文支持、模组别名备注、多编码支持等功能。**

> **🤖 AI 协作说明**：本项目在开发过程中广泛使用 AI 辅助编程。所有由 AI 生成的代码修改均标注 `# AI-generated: [description]` 注释，经过人工审核和测试。

---

## 🆕 新增功能（v1.4.2 ）

### ✨ 模组别名备注系统
- **右键设置别名**：在已安装模组列表中右键点击模组，可设置中文别名备注
- **智能显示格式**：别名显示为 `备注 | 模组名称`，方便快速识别
- **搜索增强**：搜索框支持通过别名或模组名称查找，任一匹配即可显示

### 🌐 中文编码完整支持
- **多编码解析**：支持 UTF-8、UTF-8 with BOM、GBK、GB2312、GB18030、CP936 等多种编码
- **智能编码检测**：自动尝试多种编码，确保中文 mod.info 文件正确读取
- **中文显示修复**：修复了 UTF-8 中文内容被 `unicode_escape` 错误解码导致的乱码问题

### 🛠️ 技术改进
- 修复 `ModInfoParser` 中文编码解析逻辑
- 增强 `ModManagerView` 文本处理，保护 UTF-8 中文字符
- 优化搜索过滤逻辑，支持 alias 字段检索
- 新增配置文件持久化存储（基于 QSettings）
### 📦 读取本地mod支持
  - 读取本地mod会将 mod.info所在文件夹名称写入options.set
  - 本地 mod 显示 📦 图标
  - 创意工坊 mod 显示 🎮 图标



## 系统要求

- Python **3.12** 或更高版本
- pip（Python 包管理器）

---

## 安装

1. **克隆仓库**：

```bash
git clone https://github.com/HonoriusAD395/goh-mod-manager-HA.git
cd goh-mod-manager-HA
```

2. **安装依赖**：

```bash
python -m pip install pyside6 loguru packaging requests py7zr rarfile vdf
```

---

## 使用方法

运行应用程序：

```bash
python -m goh_mod_manager
```

---

## 功能特性

### 核心功能
- ✅ 模组安装/卸载管理
- ✅ 模组启用/禁用切换
- ✅ 模组依赖关系检测
- ✅ 预设管理（保存/加载配置）
- ✅ 配置分享码导出/导入
- ✅ 模组详细信息查看

### 增强功能（本版本）
- ✨ 模组别名备注（支持中文）
- ✨ 别名搜索功能
- ✨ 中文 mod.info 完整支持
- ✨ 右键菜单快捷操作
- ✨ 自动编码检测

---

## 构建发布版

### 编译翻译文件（可选）

```bash
# Windows
scripts\qt\compile_translations.ps1

# Linux
for f in goh_mod_manager/i18n/*.ts; do python -m pyside6-lrelease "$f"; done
```

**PyInstaller（Windows）**

```bash
python -m PyInstaller ^
            --onefile ^
            --clean ^
            --windowed ^
            --name "GoH_Mod_Manager_HA" ^
            --icon "goh_mod_manager\res\icon\logo.ico" ^
            goh_mod_manager\__main__.py
```

**PyInstaller（Linux）**

```bash
python -m PyInstaller \
            --onefile \
            --clean \
            --windowed \
            --name "GoH_Mod_Manager_HA" \
            --icon "goh_mod_manager/res/icon/logo.png" \
            goh_mod_manager/__main__.py
```

编译后的可执行文件将在 `dist` 目录中生成。

---

## 依赖项

- **PySide6** - Qt for Python GUI 框架
- **loguru** - 日志记录库
- **packaging** - 版本比较工具
- **requests** - HTTP 请求库
- **py7zr** - 7z 压缩支持
- **rarfile** - RAR 压缩支持
- **vdf** - Valve Data Format 解析器
- **PyInstaller** - 独立可执行文件构建器（发布推荐）

---

## 修改记录

### v1.4.3 AI 增强版（当前版本）
**🤖 AI 协作开发新增：**

#### 模组来源标注功能
- [NEW] # AI-generated: 在 Installed Mods 列表中添加模组来源标识
  - 🎮 图标表示 Steam Workshop 模组
  - 📦 图标表示本地模组
  - 鼠标悬停显示详细信息（ID、文件夹名、模组名称）
- [NEW] # AI-generated: Active Mods 列表同步添加来源标注
- [IMP] # AI-generated: 优化路径判断逻辑，使用字符串分割替代 Path 避免缓存问题
- [IMP] # AI-generated: 添加调试日志输出，便于问题排查

#### 交互体验优化
- [FIX] # AI-generated: 修复 Installed Mods 列表双击跳转 Bug
  - 禁用列表项编辑功能 (`setEditTriggers(NoEditTriggers)`)
  - 防止双击时滚动条跳转到顶部
- [FIX] # AI-generated: 修复 PyInstaller 打包时 email 模块缺失问题
  - 从 excludes 列表中移除 email 模块
  - PySide6 的 importlib.metadata 依赖 email 模块

#### 代码质量规范
- [IMP] # AI-generated: 所有代码修改添加 `# AI-generated: [description]` 标注
  - 便于追踪 AI 生成的代码
  - 符合开发规范要求
- [IMP] # AI-generated: 优化注释和文档字符串
  - 所有新增功能均附详细说明
  - 创建技术文档记录修改内容

#### 打包配置优化
- [NEW] # AI-generated: 创建完整的 PyInstaller 打包配置
  - `build_executable.spec` - 自动化打包配置文件
  - `build.bat` - 一键打包脚本
  - `test_exe.bat` - 快速测试脚本
- [IMP] # AI-generated: 优化 spec 配置
  - 自动收集所有子模块
  - 包含所有必要资源文件
  - 排除不必要的系统模块

**技术文档：**
- [DOC] # AI-generated: `MOD_SOURCE_INDICATOR.md` - 模组来源标注功能说明
- [DOC] # AI-generated: `BUGFIX_DOUBLE_CLICK_SCROLL_20260415.md` - 双击跳转 Bug 修复报告
- [DOC] # AI-generated: `BUG_FIX_20260415.md` - NameError 和缓存问题修复
- [DOC] # AI-generated: `BUILD_SUMMARY_20260416.md` - 可执行文件打包总结
- [DOC] # AI-generated: `RELEASE_NOTES_v1.0.md` - 版本发布说明

---

### v1.4.2 cn (HonoriusAD395 增强版)
**新增功能：**
- [NEW] 模组别名备注系统
  - 右键菜单添加"Set Alias"和"Clear Alias"选项
  - 支持中文别名输入
  - 列表显示格式：`别名 | 模组名称`
- [NEW] 搜索增强
  - 搜索框支持 alias 字段匹配
  - 支持别名和模组名称双重检索
- [NEW] 中文编码完整支持
  - 新增 UTF-8-sig、GB18030、CP936 编码支持
  - 智能编码检测，自动识别文件编码
  - 修复中文 mod.info 乱码问题
- [NEW] 读取本地mod支持
  - 读取本地mod会将 mod.info所在文件夹名称写入options.set
  - 本地 mod 显示 📦 图标
  - 创意工坊 mod 显示 🎮 图标

**Bug 修复：**
- [FIX] 修复 `parse_formatted_text` 方法中 `unicode_escape` 解码破坏 UTF-8 中文
- [FIX] 修复 `_filter_list_widget` 搜索不包含 alias 字段
- [FIX] 修复 `ModInfoParser._load_file` 编码支持不完整

**代码改进：**
- [IMP] `core/mod.py` - 新增 `alias` 字段及 `__str__` 方法优化
- [IMP] `infrastructure/mod_info_parser.py` - 扩展编码支持列表
- [IMP] `infrastructure/config_manager.py` - 新增别名存储方法
- [IMP] `presentation/controller/mod_manager_controller.py` - 新增别名相关控制器
- [IMP] `presentation/view/mod_manager_view.py` - 优化文本处理逻辑

---

## 鸣谢

- Logo 设计：[awasde](https://www.linkedin.com/in/amélie-rakowiecki-970818350)
- 原始模组管理器：[Elaindil (MrCookie)](https://github.com/Elaindil/ModManager)
- 原项目作者：[alexbdka](https://github.com/alexbdka)

---

## 许可证

本项目基于原 [alexbdka/goh-mod-manager](https://github.com/alexbdka/goh-mod-manager) 二次开发，遵循原项目许可证。

---

## 联系方式

如有问题或建议，欢迎提交 Issue 或 Pull Request。

**作者**：HonoriusAD395 (独轮车)  
**GitHub**：https://github.com/HonoriusAD395/goh-mod-manager-cn
