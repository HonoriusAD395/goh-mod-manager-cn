# GoH Mod Manager 工作流程详解

## 📋 目录
1. [架构概览](#架构概览)
2. [启动流程](#启动流程)
3. [核心组件](#核心组件)
4. [数据流](#数据流)
5. [用户交互流程](#用户交互流程)
6. [关键功能实现](#关键功能实现)

---

## 架构概览

本软件采用 **MVC (Model-View-Controller)** + **ViewModel** 架构模式：

```
┌─────────────────────────────────────────────┐
│           Presentation Layer                │
│  ┌──────────┐    ┌──────────────────────┐   │
│  │   View   │◄──►│     Controller       │   │
│  │  (UI)    │    │  (Event Handler)     │   │
│  └──────────┘    └──────────┬───────────┘   │
│                             │               │
│                    ┌────────▼──────────┐    │
│                    │   ViewModels      │    │
│                    │ (Business Logic)  │    │
│                    └────────┬──────────┘    │
└─────────────────────────────┼───────────────┘
                              │
┌─────────────────────────────┼───────────────┐
│          Domain Layer       │               │
│                    ┌────────▼──────────┐    │
│                    │      Model        │    │
│                    │  (Data & State)   │    │
│                    └────────┬──────────┘    │
└─────────────────────────────┼───────────────┘
                              │
┌─────────────────────────────┼───────────────┐
│       Infrastructure Layer  │               │
│                    ┌────────▼──────────┐    │
│                    │    Services       │    │
│                    │  (External Ops)   │    │
│                    └────────┬──────────┘    │
│                             │               │
│                    ┌────────▼──────────┐    │
│                    │   ConfigManager   │    │
│                    │  (QSettings)      │    │
│                    └───────────────────┘    │
└─────────────────────────────────────────────┘
```

---

## 启动流程

### 1. 应用入口 (`__main__.py`)

```python
main()
  ↓
创建 QApplication
  ↓
初始化 ConfigManager (读取配置)
  ↓
加载翻译文件 (i18n/translator.py)
  ↓
创建 ModManagerApp
  ├─ ModManagerModel (数据层)
  ├─ ModManagerView (视图层)
  └─ ModManagerController (控制器)
  ↓
显示主窗口
  ↓
进入 Qt 事件循环 (app.exec())
```

### 2. 初始化顺序

#### Step 1: ConfigManager 初始化
```python
ConfigManager.__init__()
  ↓
创建 QSettings ("alex6", "GoH Mod Manager")
  ↓
first_run() - 首次运行检测
  ├─ 检测系统语言 → 设置默认语言
  ├─ 自动查找游戏目录
  ├─ 自动查找模组目录
  └─ 自动查找 options.set 文件
```

#### Step 2: Model 初始化
```python
ModManagerModel.__init__()
  ↓
初始化数据结构
  ├─ _installed_mods = [] (已安装模组列表)
  ├─ _active_mods = [] (已激活模组列表)
  └─ _presets = {} (预设字典)
  ↓
初始化服务层
  ├─ ModsCatalogService (模组扫描)
  ├─ ActiveModsService (激活管理)
  ├─ PresetsService (预设管理)
  └─ ModImportService (模组导入)
```

#### Step 3: View 初始化
```python
ModManagerView.__init__()
  ↓
加载 UI (MainWindow.ui)
  ↓
初始化界面元素
  ├─ 模组列表 (QListWidget)
  ├─ 搜索框 (QLineEdit)
  ├─ 预设下拉框 (QComboBox)
  └─ 详情面板 (QTextEdit)
```

#### Step 4: Controller 初始化
```python
ModManagerController.__init__(model, view)
  ↓
_initialize()
  ├─ _ensure_config_valid() - 确保配置有效
  ├─ _connect_signals() - 连接信号槽
  ├─ _load_data() - 加载初始数据
  ├─ _apply_user_preferences() - 应用用户偏好
  └─ _setup_guided_tour() - 设置引导教程
```

---

## 核心组件

### 1. Model 层 (`core/mod_manager_model.py`)

**职责：** 管理应用状态和业务逻辑

#### 核心数据结构
```python
class ModManagerModel(QObject):
    _installed_mods: List[Mod]      # 所有已安装模组
    _active_mods: List[Mod]         # 当前激活的模组
    _presets: Dict[str, List[Mod]]  # 预设集合
    _config: ConfigManager          # 配置管理器
```

#### 关键方法
```python
# 模组管理
enable_mod(mod)          # 启用模组
disable_mod(mod)         # 禁用模组
delete_mod(mod)          # 删除模组
set_mods_order(mods)     # 设置模组顺序

# 预设管理
save_preset(name)        # 保存预设
load_preset(name)        # 加载预设
delete_preset(name)      # 删除预设

# 刷新机制
refresh_installed_mods() # 刷新已安装模组
refresh_active_mods()    # 刷新激活模组
refresh_all()            # 全部刷新
```

#### 信号机制
```python
installed_mods_signal.emit()      # 已安装模组变化
presets_signal.emit()             # 预设变化
mods_counter_signal.emit(count)   # 激活模组数量变化
```

---

### 2. View 层 (`presentation/view/mod_manager_view.py`)

**职责：** 用户界面展示和交互

#### 主要 UI 组件
```python
class ModManagerView(QMainWindow):
    ui.listWidget_installed_mods   # 已安装模组列表
    ui.listWidget_active_mods      # 已激活模组列表
    ui.lineEdit_search_*           # 搜索框
    ui.comboBox_presets            # 预设选择器
    ui.textEdit_mod_details        # 模组详情
```

#### 关键方法
```python
populate_mod_lists(installed, active)  # 填充模组列表
show_mod_details(mod)                  # 显示模组详情
update_active_mods_count(count)        # 更新计数器
parse_formatted_text(text)             # 解析格式化文本
parse_clear_text(text)                 # 清除格式文本
```

---

### 3. Controller 层 (`presentation/controller/mod_manager_controller.py`)

**职责：** 协调 View 和 Model，处理用户输入

#### ViewModel 集合
```python
class ModManagerController(QObject):
    _view_model: MainViewModel                    # 主视图模型
    _import_export_view_model: ImportExportVM     # 导入导出
    _presets_view_model: PresetsViewModel         # 预设管理
    _mod_actions_view_model: ModActionsViewModel  # 模组操作
    _file_actions_view_model: FileActionsViewModel # 文件操作
    _appearance_view_model: AppearanceViewModel   # 外观设置
```

#### 信号连接
```python
_connect_signals()
  ├─ _connect_view_model_signals()    # ViewModel 信号
  ├─ _connect_menu_signals()          # 菜单动作
  ├─ _connect_button_signals()        # 按钮点击
  ├─ _connect_list_signals()          # 列表事件
  └─ _connect_ui_signals()            # UI 组件事件
```

---

### 4. Service 层 (`services/*.py`)

**职责：** 封装外部操作和业务逻辑

#### 服务列表
| 服务 | 职责 |
|------|------|
| `ModsCatalogService` | 扫描文件系统，识别已安装模组 |
| `ActiveModsService` | 管理 options.set 中的激活模组 |
| `PresetsService` | 预设的保存、加载、解析 |
| `ModImportService` | 从压缩包/文件夹导入模组 |
| `ShareCodeService` | 生成/解析分享码 (Base64) |
| `DependenciesService` | 检测模组依赖关系 |
| `FontService` | 字体管理 |
| `SystemActionsService` | 系统级操作（打开文件夹等） |

---

## 数据流

### 1. 模组加载流程

```
启动应用
  ↓
ConfigManager.first_run()
  ↓
自动查找路径
  ├─ 游戏目录 → game_directory
  ├─ 模组目录 → mods_directory
  └─ 配置文件 → options_file
  ↓
ModManagerModel._load_installed_mods()
  ↓
ModsCatalogService.scan_installed_mods()
  ├─ 扫描 mods_directory
  ├─ 扫描 game_mods_directory
  └─ 解析每个模组的 mod.info
      ↓
  ModInfoParser.parse()
      ├─ 尝试多种编码 (UTF-8, GBK, etc.)
      ├─ 解析字段 (name, desc, version, etc.)
      └─ 创建 Mod 对象
  ↓
应用保存的 Alias
  ├─ ConfigManager.get_mod_aliases()
  └─ 为每个 Mod 设置 alias 字段
  ↓
Model.installed_mods_signal.emit()
  ↓
ViewModel 接收信号
  ↓
View.populate_mod_lists()
  ↓
显示在 UI 列表中
```

### 2. 激活模组流程

```
用户点击 "Enable" 按钮
  ↓
Controller._enable_selected_mods()
  ↓
ModActionsViewModel.enable_mods(mods)
  ↓
Model.enable_mod(mod)
  ├─ 添加到 _active_mods 列表
  └─ Model._save_active_mods()
      ↓
  ActiveModsService.save_active_mods()
      ├─ 读取 options.set
      ├─ 更新 [mods] 段
      └─ 写回文件
  ↓
Model.mods_counter_signal.emit(count)
  ↓
View.update_active_mods_count(count)
  ↓
刷新 UI 列表
```

### 3. 预设保存流程

```
用户点击 "Save Preset"
  ↓
Controller._save_preset()
  ↓
DialogActionsViewModel.open_save_preset_dialog()
  ↓
PresetDialog (用户输入名称)
  ↓
PresetsViewModel.save_preset(name)
  ↓
Model.save_preset(name)
  ├─ _presets[name] = _active_mods.copy()
  └─ Model._save_presets_to_config()
      ↓
  ConfigManager.set_presets(presets)
      └─ QSettings.setValue("presets", presets)
  ↓
Model.presets_signal.emit()
  ↓
View.refresh_presets_combo()
```

### 4. 分享码导出流程

```
用户点击 "Export Load Order as Code"
  ↓
Controller._open_export_code()
  ↓
ImportExportViewModel.get_share_code()
  ↓
ShareCodeService.encode_mods(active_mods)
  ├─ 提取模组 ID 列表
  ├─ 转换为 JSON
  ├─ Base64 编码
  └─ 返回编码字符串
  ↓
ExportCodeDialog (显示分享码)
  ↓
用户复制分享码
```

### 5. 分享码导入流程

```
用户点击 "Import Load Order from Code"
  ↓
Controller._open_import_code()
  ↓
ImportCodeDialog (用户粘贴分享码)
  ↓
ShareCodeService.decode_mods(code)
  ├─ Base64 解码
  ├─ 解析 JSON
  └─ 返回模组 ID 列表
  ↓
ImportDetailsDialog (显示将要导入的模组)
  ↓
用户确认
  ↓
Model.load_preset_from_ids(mod_ids)
  ├─ 清空当前激活模组
  ├─ 根据 ID 查找 Mod 对象
  └─ 设置为新的激活列表
  ↓
刷新 UI
```

---

## 用户交互流程

### 场景 1: 启用/禁用模组

```
1. 用户在 "Installed Mods" 列表中选择模组
2. 点击 "Enable" 按钮
3. Controller 调用 ViewModel
4. ViewModel 调用 Model.enable_mod()
5. Model 更新 _active_mods 并保存到 options.set
6. Model 发射信号通知 UI 更新
7. View 刷新两个列表（从 Installed 移到 Active）
8. 更新激活模组计数器
```

### 场景 2: 设置模组别名 (Alias)

```
1. 用户在 "Installed Mods" 列表右键点击模组
2. 选择 "Set Alias" 菜单项
3. Controller._show_mod_context_menu() 触发
4. 弹出 QInputDialog 输入框
5. 用户输入别名（支持中文）
6. Controller._set_mod_alias()
   ├─ mod.alias = 用户输入
   ├─ ConfigManager.set_mod_alias(mod_id, alias)
   └─ 保存到 QSettings
7. Controller._refresh_mod_lists()
8. View 重新渲染列表，显示 "别名 | 模组名"
```

### 场景 3: 搜索模组

```
1. 用户在搜索框输入文本
2. QLineEdit.textChanged 信号触发
3. Controller._filter_installed_mods(search_text)
4. 遍历列表中的每个模组
5. 检查以下条件（任一匹配即显示）：
   ├─ search_text in mod.name
   ├─ search_text in mod.desc
   ├─ search_text in mod.id
   └─ search_text in mod.alias  ← AI 新增
6. 调用 item.setHidden(not is_visible)
7. UI 实时过滤显示结果
```

### 场景 4: 导入本地模组

```
1. 用户点击 "Import Local Mod"
2. Controller._import_mod()
3. FileActionsViewModel.import_mod(path)
4. 显示进度对话框
5. ModImportService.import_mod(path, dest_dir)
   ├─ 检测文件类型 (.zip, .7z, .rar, folder)
   ├─ 解压到游戏模组目录
   ├─ 创建 .imported_by_mod_manager 标记文件
   └─ 解析 mod.info
6. 导入成功后刷新已安装模组列表
7. 显示成功消息
```

### 场景 5: 保存/加载预设

```
保存预设：
1. 用户调整激活模组列表
2. 点击 "Save Preset"
3. 输入预设名称
4. Model.save_preset(name)
5. 保存到 QSettings

加载预设：
1. 用户从下拉框选择预设
2. ComboBox.currentIndexChanged 触发
3. Controller._on_preset_selection_changed(name)
4. Model.load_preset(name)
5. 清空当前激活模组
6. 加载预设中的模组列表
7. 保存到 options.set
8. 刷新 UI
```

---

## 关键功能实现

### 1. 多编码支持 (AI 增强)

**位置：** `infrastructure/mod_info_parser.py`

```python
def _load_file(self) -> bool:
    # 尝试多种编码
    encodings_to_try = [
        "utf-8",      # 标准 UTF-8
        "utf-8-sig",  # UTF-8 with BOM
        "gb18030",    # 中文国标
        "gbk",        # 简体中文
        "gb2312",     # 早期中文编码
        "cp936",      # Windows 中文代码页
        "latin-1"     # 兜底编码
    ]
    
    for encoding in encodings_to_try:
        try:
            with open(file_path, "r", encoding=encoding) as f:
                content = f.read()
            if content.strip():
                return True  # 成功加载
        except UnicodeDecodeError:
            continue  # 尝试下一个编码
    
    return False  # 所有编码都失败
```

### 2. UTF-8 中文保护 (AI 增强)

**位置：** `presentation/view/mod_manager_view.py`

```python
@staticmethod
def parse_formatted_text(text: str) -> str:
    # 检测是否包含非 ASCII 字符（中文等）
    has_non_ascii = any(ord(c) > 127 for c in text)
    
    if not has_non_ascii:
        # ASCII 文本可以安全使用 unicode_escape
        text = bytes(text, "utf-8").decode("unicode_escape")
    else:
        # 含中文的文本，手动处理转义序列
        text = text.replace("\\n", "\n")
        
        def replace_unicode_escape(match):
            hex_str = match.group(0)[2:]
            try:
                return chr(int(hex_str, 16))
            except ValueError:
                return match.group(0)
        
        text = re.sub(r"\\u[0-9a-fA-F]{4}", replace_unicode_escape, text)
    
    return text
```

### 3. Alias 持久化 (AI 增强)

**位置：** `infrastructure/config_manager.py`

```python
def set_mod_alias(self, mod_id: str, alias: str) -> None:
    aliases = self.get_mod_aliases()  # 从 QSettings 读取
    if alias:
        aliases[mod_id] = alias       # 设置别名
    elif mod_id in aliases:
        del aliases[mod_id]           # 删除空别名
    self.settings.setValue("mod_aliases", aliases)  # 保存
```

**加载时应用：**
```python
# core/mod_manager_model.py
def _load_installed_mods(self):
    # ... 扫描模组 ...
    
    # 应用保存的别名
    saved_aliases = self._config.get_mod_aliases()
    for mod in self._installed_mods:
        if mod.id in saved_aliases:
            mod.alias = saved_aliases[mod.id]
```

### 4. 信号槽机制

**Model → View 通信：**
```python
# Model 发射信号
self.installed_mods_signal.emit()

# Controller 连接信号
self._view_model.mods_lists_changed.connect(self._on_mods_lists_changed)

# View 更新 UI
def _on_mods_lists_changed(self):
    installed = self._view_model.get_installed_mods()
    active = self._view_model.get_active_mods()
    self._view.populate_mod_lists(installed, active)
```

---

## 配置文件存储

### QSettings 结构

```ini
[General]
mods_directory=C:/Users/.../workshop/content/400750
game_directory=C:/Program Files/Steam/steamapps/common/Call to Arms - Gates of Hell
options_file=C:/Users/.../Documents/My Games/gates of hell/profiles/xxx/options.set
language=en
font=default
show_guided_tour=true

[presets]
preset1=["mod_id_1", "mod_id_2"]
preset2=["mod_id_3"]

[mod_aliases]
mod_id_1=我的备注
mod_id_2=测试模组
```

---

## 总结

### 架构优势

1. **分层清晰**：MVC + ViewModel 分离关注点
2. **可扩展性**：Service 层便于添加新功能
3. **响应式 UI**：Qt 信号槽实现数据驱动
4. **配置持久化**：QSettings 自动管理
5. **国际化支持**：TranslationManager 动态切换语言

### 数据流向

```
用户操作 → View 事件 → Controller → ViewModel → Model → Service → 文件系统
                                                                    ↓
UI 更新 ← View 渲染 ← Controller ← ViewModel ← Model 信号 ← 数据变化
```

### AI 增强特性

1. ✅ 模组别名系统（支持中文）
2. ✅ 多编码 mod.info 解析
3. ✅ UTF-8 中文保护
4. ✅ 增强的搜索功能（支持 alias）
5. ✅ 完整的标注体系

---

**版本：** v1.4.2 HA  
**最后更新：** 2026-04-15  
**作者：** HonoriusAD395
