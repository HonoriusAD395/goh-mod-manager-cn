# GoH Mod Manager - PowerShell 启动指南

## 🚀 快速启动

### 方法 1: 使用 uv（推荐）

```powershell
# 进入项目目录
cd B:\Work\python\goh-mod-manager-cn

# 运行应用
uv run -m goh_mod_manager
```

---

### 方法 2: 使用 Python 直接运行

```powershell
# 进入项目目录
cd B:\Work\python\goh-mod-manager-cn

# 确保已安装依赖
python -m pip install pyside6 loguru packaging requests py7zr rarfile vdf

# 运行应用
python -m goh_mod_manager
```

---

### 方法 3: 创建快捷启动脚本

在项目根目录创建 `run.ps1` 文件：

```powershell
# run.ps1
Set-Location $PSScriptRoot
uv run -m goh_mod_manager
```

**使用方法：**
```powershell
.\run.ps1
```

---

## 📋 前置条件

### 1. 安装 Python 3.12

**检查 Python 版本：**
```powershell
python --version
# 或
py --version
```

**如果未安装：**
- 下载地址：https://www.python.org/downloads/
- 选择 Python 3.12.x 版本
- 安装时勾选 "Add Python to PATH"

---

### 2. 安装 uv（包管理器）

**Windows 安装方法：**

```powershell
# 方法 1: 使用 pip
pip install uv

# 方法 2: 使用 PowerShell 脚本
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# 方法 3: 使用 winget
winget install --id=astral-sh.uv
```

**验证安装：**
```powershell
uv --version
```

---

### 3. 安装项目依赖

```powershell
# 进入项目目录
cd B:\Work\python\goh-mod-manager-cn

# 同步依赖（使用 uv）
uv sync

# 或使用 pip
python -m pip install -e .
```

---

## 🔧 常见问题

### Q1: 'uv' 不是内部或外部命令

**解决方案：**
```powershell
# 重新安装 uv
pip install uv

# 或者重启 PowerShell 使 PATH 生效
```

---

### Q2: 缺少依赖模块

**错误示例：**
```
ModuleNotFoundError: No module named 'PySide6'
```

**解决方案：**
```powershell
# 使用 uv 安装所有依赖
uv sync

# 或使用 pip
python -m pip install pyside6 loguru packaging requests py7zr rarfile vdf
```

---

### Q3: Python 版本不匹配

**错误示例：**
```
ERROR: Package requires Python >=3.12
```

**解决方案：**
```powershell
# 检查当前 Python 版本
python --version

# 如果版本过低，下载 Python 3.12
# https://www.python.org/downloads/release/python-3129/
```

---

### Q4: 权限问题

**错误示例：**
```
PermissionError: [WinError 5] Access is denied
```

**解决方案：**
```powershell
# 以管理员身份运行 PowerShell
# 右键点击 PowerShell → "以管理员身份运行"

# 或者修改文件夹权限
icacls "B:\Work\python\goh-mod-manager-cn" /grant Users:F /T
```

---

## 🎯 完整启动流程

### 首次运行

```powershell
# Step 1: 进入项目目录
cd B:\Work\python\goh-mod-manager-cn

# Step 2: 确认 Python 版本
python --version
# 应该显示: Python 3.12.x

# Step 3: 安装 uv（如果还没有）
pip install uv

# Step 4: 同步依赖
uv sync

# Step 5: 运行应用
uv run -m goh_mod_manager
```

### 日常运行

```powershell
cd B:\Work\python\goh-mod-manager-cn
uv run -m goh_mod_manager
```

---

## 📝 创建桌面快捷方式

### 方法 1: 创建 .lnk 快捷方式

1. 右键桌面 → 新建 → 快捷方式
2. 输入目标：
   ```
   C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoExit -Command "cd B:\Work\python\goh-mod-manager-cn; uv run -m goh_mod_manager"
   ```
3. 命名快捷方式为 "GoH Mod Manager"
4. （可选）更改图标

---

### 方法 2: 创建批处理文件

创建 `启动.bat` 文件：

```batch
@echo off
cd /d B:\Work\python\goh-mod-manager-cn
uv run -m goh_mod_manager
pause
```

**双击即可运行！**

---

### 方法 3: 创建 PowerShell 脚本

创建 `启动.ps1` 文件：

```powershell
# 启动 GoH Mod Manager
Set-Location "B:\Work\python\goh-mod-manager-cn"
uv run -m goh_mod_manager
```

**运行方法：**
```powershell
# 右键 → "使用 PowerShell 运行"
# 或在 PowerShell 中执行：
.\启动.ps1
```

---

## 🐛 调试模式

### 查看详细日志

```powershell
# 设置日志级别为 DEBUG
$env:GOH_MM_DEBUG = "1"
uv run -m goh_mod_manager
```

### 查看日志文件

```powershell
# 日志位置
Get-Content "B:\Work\python\goh-mod-manager-cn\logs\mod_manager.log" -Tail 50
```

---

## 📦 打包版本（无需 Python）

如果你已经构建了可执行文件：

```powershell
# 直接运行 exe
.\dist\GoH_Mod_Manager_HA.exe

# 或
.\build\GoH_Mod_Manager_HA\GoH_Mod_Manager_HA.exe
```

**构建可执行文件：**
```powershell
# 安装 PyInstaller
uv add --dev pyinstaller

# 构建
uv run pyinstaller GoH_Mod_Manager_HA.spec
```

---

## 💡 提示和技巧

### 1. 别名简化命令

在 PowerShell profile 中添加别名：

```powershell
# 编辑 profile
notepad $PROFILE

# 添加以下内容
function Start-GoH {
    Set-Location "B:\Work\python\goh-mod-manager-cn"
    uv run -m goh_mod_manager
}
Set-Alias goh Start-GoH
```

**使用：**
```powershell
goh  # 直接启动
```

---

### 2. 后台运行（无控制台窗口）

```powershell
Start-Process powershell -ArgumentList "-NoProfile -WindowStyle Hidden -Command `"cd B:\Work\python\goh-mod-manager-cn; uv run -m goh_mod_manager`""
```

---

### 3. 检查应用是否正在运行

```powershell
Get-Process | Where-Object {$_.ProcessName -like "*python*" -or $_.MainWindowTitle -like "*GoH*"}
```

---

## 📚 相关文档

- [README.md](README.md) - 项目说明
- [WORKFLOW.md](WORKFLOW.md) - 工作流程详解
- [MOD_INFO_READING.md](MOD_INFO_READING.md) - mod.info 读取机制
- [OPTIONS_SET_FORMAT.md](OPTIONS_SET_FORMAT.md) - options.set 格式说明

---

**最后更新：** 2026-04-15  
**作者：** HonoriusAD395
