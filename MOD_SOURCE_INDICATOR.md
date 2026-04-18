# 模组来源标注功能

## 📋 功能概述

在 **Installed Mods** 和 **Active Mods** 列表中，通过图标和工具提示区分 Steam 创意工坊模组和本地模组。

---

## 🎨 显示效果

### Installed Mods 列表

```
🎮 我的备注 | Steam模组名称     ← Steam Workshop
📦 测试模组 | 本地模组名称       ← Local Mod
🎮 Another Steam Mod            ← Steam Workshop
📦 gos_remove_weather           ← Local Mod
```

### Active Mods 列表

同样的标注方式应用于激活模组列表。

---

## 💡 图标说明

| 图标 | 含义 | 来源判断 |
|------|------|---------|
| 🎮 | Steam Workshop Mod | `folderPath` 包含 "workshop" |
| 📦 | Local Mod | 其他情况（游戏 Data 目录） |

---

## 🔍 工具提示（Tooltip）

### Steam Workshop 模组
```
Steam Workshop Mod
ID: 1234567890
模组完整名称
```

### 本地模组
```
Local Mod
Folder: remove60ptree
模组完整名称
```

**使用方法：** 鼠标悬停在模组名称上即可查看详细信息。

---

## 🔧 技术实现

### 修改的文件
- `presentation/view/mod_manager_view.py` - `_add_mod_to_list()` 方法

### 核心逻辑

```python
# AI-generated: Add source indicator icon and tooltip
if "workshop" in mod.folderPath.lower():
    # Steam Workshop mod
    icon_prefix = "🎮 "
    tooltip = f"Steam Workshop Mod\nID: {mod.id}\n{mod.name}"
else:
    # Local/Data directory mod
    icon_prefix = "📦 "
    tooltip = f"Local Mod\nFolder: {Path(mod.folderPath).name}\n{mod.name}"

# Create list item with icon prefix
item = QListWidgetItem(icon_prefix + clear_name)
item.setData(Qt.UserRole, mod)
item.setToolTip(tooltip)  # AI-generated: Set hover tooltip
```

### 判断依据
通过检查 `mod.folderPath` 是否包含 `"workshop"` 关键字：
- ✅ 包含 → Steam Workshop 模组
- ❌ 不包含 → 本地模组

---

## ✨ 功能特性

### 1. 视觉区分
- 🎮 蓝色游戏手柄图标 = Steam Workshop
- 📦 棕色包裹图标 = Local Mod

### 2. 信息丰富
- 列表项显示：图标 + 别名（如果有）+ 模组名
- 悬停提示：来源类型 + ID/文件夹名 + 完整名称

### 3. 兼容性好
- ✅ 与 Alias 功能完美配合
- ✅ 不影响搜索功能
- ✅ 不影响模组启用/禁用
- ✅ 支持粗体显示（手动安装模组）

### 4. 国际化友好
- 使用通用图标，无需翻译
- Tooltip 使用英文，全球用户都能理解

---

## 📊 示例对比

### 修改前
```
我的备注 | Steam模组名称
测试模组 | 本地模组名称
gos_remove_weather
```

### 修改后
```
🎮 我的备注 | Steam模组名称
📦 测试模组 | 本地模组名称
📦 gos_remove_weather
```

---

## 🎯 用户体验提升

### 优势
1. ✅ **快速识别** - 一眼看出模组来源
2. ✅ **节省空间** - 图标比文字标签更紧凑
3. ✅ **信息完整** - Tooltip 提供详细信息
4. ✅ **美观简洁** - Emoji 图标现代感强

### 适用场景
- 管理大量模组时快速筛选
- 排查问题时区分来源
- 分享配置时说明模组类型

---

## 🧪 测试建议

### 测试用例 1: Steam Workshop 模组
```
操作：查看已安装的 Steam 模组
预期：显示 🎮 图标，悬停显示 "Steam Workshop Mod"
```

### 测试用例 2: 本地模组
```
操作：查看 data/mods/ 下的模组
预期：显示 📦 图标，悬停显示 "Local Mod"
```

### 测试用例 3: 带别名的模组
```
操作：设置别名 "测试" 的本地模组
预期：显示 "📦 测试 | 模组名称"
```

### 测试用例 4: 混合列表
```
操作：同时查看 Steam 和本地模组
预期：两种图标正确显示，不混淆
```

---

## ⚙️ 自定义选项

如果需要修改图标或提示文本，可以编辑：

**文件位置：** `presentation/view/mod_manager_view.py`  
**方法：** `_add_mod_to_list()`  
**行号：** 约 558-572 行

```python
# 修改图标
icon_prefix = "🎮 "  # 改为其他 Emoji 或文字

# 修改提示文本
tooltip = f"自定义提示文本\n..."
```

---

## 📝 注意事项

1. **Emoji 显示**
   - 确保系统支持 Emoji 显示
   - Windows 10+ 默认支持
   - 如果显示为方框，可能是字体问题

2. **性能影响**
   - 59个模组的图标渲染几乎无性能影响
   - Tooltip 只在悬停时显示

3. **搜索功能**
   - 搜索时会匹配图标后的文本
   - 图标本身不参与搜索

4. **导出分享码**
   - 图标不影响分享码生成
   - 分享码只包含模组 ID

---

## 🔄 与其他功能的配合

### ✅ Alias 功能
```
🎮 别名 | 模组名     ← 完美配合
```

### ✅ 搜索功能
```
搜索 "别名" → 找到 "🎮 别名 | 模组名"
搜索 "模组名" → 找到 "🎮 别名 | 模组名"
```

### ✅ 粗体显示（手动安装）
```
📦 模组名 (粗体)    ← 手动安装的本地模组
```

---

**最后更新：** 2026-04-15  
**相关文档：** 
- [WORKFLOW.md](WORKFLOW.md) - 工作流程
- [OPTIONS_SET_FORMAT.md](OPTIONS_SET_FORMAT.md) - options.set 格式
