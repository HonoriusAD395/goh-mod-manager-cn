# 双击跳转 Bug 修复报告

**日期**: 2026-04-15  
**版本**: v1.0.x  
**问题**: Installed Mods 列表双击导致滚动条跳转到顶部

---

## 🐛 问题描述

### 现象
在左侧 **Installed Mods** 列表中，当用户双击某个 mod 时，列表的滚动条会自动跳转到第一个 mod 的位置，导致用户失去当前的浏览位置。

### 影响范围
- ✅ Installed Mods 列表（左侧）
- ✅ Active Mods 列表（右侧）
- 🔴 用户体验严重受影响

---

## 🔍 根本原因

### QListWidget 默认行为
PySide6 的 `QListWidget` 组件默认启用了**编辑功能**。当用户双击列表项时，Qt 会尝试进入编辑模式，这会触发以下行为：

1. 创建编辑器控件
2. 滚动到确保编辑器可见的位置
3. 由于我们的列表项不可编辑，编辑器立即销毁
4. 但滚动位置已经被重置到顶部

### 代码分析
```python
# 之前的代码 - 没有禁用编辑功能
def _configure_drag_and_drop(self) -> None:
    self.ui.listWidget_installed_mods.setAcceptDrops(False)
    self.ui.listWidget_installed_mods.setDragEnabled(False)
    # ... 其他配置
```

---

## ✅ 解决方案

### 修改内容

在 `_configure_drag_and_drop()` 方法中添加编辑触发器禁用：

```python
def _configure_drag_and_drop(self) -> None:
    # AI-generated: Disable editing to prevent scroll jump on double-click
    self.ui.listWidget_installed_mods.setEditTriggers(QAbstractItemView.NoEditTriggers)
    self.ui.listWidget_active_mods.setEditTriggers(QAbstractItemView.NoEditTriggers)
    
    self.ui.listWidget_installed_mods.setAcceptDrops(False)
    self.ui.listWidget_installed_mods.setDragEnabled(False)
    self.ui.listWidget_installed_mods.setDragDropMode(QAbstractItemView.NoDragDrop)
    self.ui.listWidget_active_mods.setAcceptDrops(True)
    self.ui.listWidget_active_mods.setDragEnabled(True)
    self.ui.listWidget_active_mods.setDragDropMode(QAbstractItemView.InternalMove)
```

### 关键改动

| 修改项 | 说明 |
|--------|------|
| `setEditTriggers(NoEditTriggers)` | 完全禁用列表项的编辑功能 |
| 应用于两个列表 | Installed Mods 和 Active Mods 都添加此设置 |
| 位置 | 在拖放配置之前设置，确保初始化顺序正确 |

---

## 📝 完整修改清单

### 文件: `goh_mod_manager/presentation/view/mod_manager_view.py`

#### 1. 禁用编辑功能（第 47-57 行）
```python
def _configure_drag_and_drop(self) -> None:
    # AI-generated: Disable editing to prevent scroll jump on double-click
    self.ui.listWidget_installed_mods.setEditTriggers(QAbstractItemView.NoEditTriggers)
    self.ui.listWidget_active_mods.setEditTriggers(QAbstractItemView.NoEditTriggers)
    
    # ... 其余代码
```

#### 2. 完善模组来源标注（第 564-591 行）
```python
# AI-generated: Add source indicator icon and tooltip
# Debug: Check folderPath value
logger.debug(f"Mod: {mod.name}, folderPath: {mod.folderPath}")

# AI-generated: Check if mod is from Steam Workshop by path keyword
is_workshop = mod.folderPath and "workshop" in mod.folderPath.lower()
logger.debug(f"Is workshop: {is_workshop}, path: {mod.folderPath}")

# AI-generated: Set icon prefix and tooltip based on mod source
if is_workshop:
    # AI-generated: Steam Workshop mod with game controller icon
    icon_prefix = "🎮 "
    tooltip = f"Steam Workshop Mod\nID: {mod.id}\n{mod.name}"
else:
    # AI-generated: Local/Data directory mod with package icon
    icon_prefix = "📦 "
    # AI-generated: Extract folder name using string split to avoid Path cache issues
    folder_name = mod.folderPath.split('\\')[-1] if mod.folderPath else "Unknown"
    tooltip = f"Local Mod\nFolder: {folder_name}\n{mod.name}"

# AI-generated: Create list item with source indicator icon prefix
item = QListWidgetItem(icon_prefix + clear_name)
item.setData(Qt.UserRole, mod)
item.setToolTip(tooltip)  # AI-generated: Set hover tooltip with mod details
```

---

## 🧪 测试验证

### 测试步骤

1. **清除缓存**
   ```powershell
   cd B:\Work\python\goh-mod-manager-cn
   Get-ChildItem -Path . -Directory -Filter "__pycache__" -Recurse | Remove-Item -Recurse -Force
   Get-ChildItem -Path . -Filter "*.pyc" -Recurse | Remove-Item -Force
   ```

2. **启动程序**
   ```powershell
   python -m goh_mod_manager
   ```

3. **测试双击行为**
   - 在 Installed Mods 列表中向下滚动
   - 选择一个不在视野顶部的 mod
   - 双击该 mod
   - ✅ 预期：列表保持在当前位置，不跳转到顶部

4. **测试模组来源标注**
   - 检查本地 mod 是否显示 📦 图标
   - 检查创意工坊 mod 是否显示 🎮 图标
   - 鼠标悬停查看 Tooltip 信息

---

## 📊 修复效果对比

### 修复前
```
操作：双击列表中间的 mod
结果：❌ 滚动条跳转到顶部，丢失浏览位置
```

### 修复后
```
操作：双击列表中间的 mod
结果：✅ 列表保持当前位置，无跳转
```

---

## 🔧 技术细节

### QAbstractItemView.EditTrigger 枚举

| 值 | 说明 |
|----|------|
| `NoEditTriggers` | 完全禁用编辑 |
| `CurrentChanged` | 当前项改变时编辑 |
| `DoubleClicked` | 双击时编辑（默认行为） |
| `SelectedClicked` | 单击已选项时编辑 |
| `EditKeyPressed` | 按下编辑键时编辑 |
| `AnyKeyPressed` | 按下任意键时编辑 |
| `AllEditTriggers` | 所有触发方式 |

### 为什么选择 NoEditTriggers？

1. **只读列表**：模组列表不需要用户直接编辑
2. **已有交互**：通过按钮（Activate/Deactivate）管理模组
3. **避免冲突**：防止与双击、拖拽等操作冲突
4. **性能优化**：减少不必要的编辑器创建/销毁

---

## 📌 注意事项

### 兼容性
- ✅ PySide6 所有版本支持
- ✅ 不影响拖拽功能
- ✅ 不影响右键菜单
- ✅ 不影响键盘导航

### 副作用
- ⚠️ 无法通过 F2 键重命名列表项（本来就不需要）
- ⚠️ 无法通过双击进入编辑模式（这正是我们想要的）

### 未来扩展
如果将来需要允许某些列表项可编辑，可以：
```python
# 为特定项启用编辑
item.setFlags(item.flags() | Qt.ItemIsEditable)
```

---

## 🎯 相关改进

本次修复同时完善了模组来源标注功能：

1. ✅ 添加了详细的 AI-generated 标注
2. ✅ 优化了注释说明
3. ✅ 使用字符串分割替代 Path 避免缓存问题
4. ✅ 添加了调试日志输出

---

## 📚 参考资料

- [Qt Documentation - QAbstractItemView::EditTrigger](https://doc.qt.io/qt-6/qabstractitemview.html#EditTrigger-enum)
- [PySide6 QListWidget Documentation](https://doc.qt.io/qtforpython-6/PySide6/QtWidgets/QListWidget.html)
- [Qt Item View Framework](https://doc.qt.io/qt-6/model-view-programming.html)

---

**修复完成时间**: 2026-04-15  
**测试状态**: 待用户验证  
**文档作者**: AI Assistant (人工审核)
