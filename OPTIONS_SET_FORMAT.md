# Options.set 模组格式区分说明

## 📋 修改概述

根据模组的来源目录，在写入 `options.set` 时使用不同的格式：

| 模组来源 | options.set 格式 | 示例 |
|---------|-----------------|------|
| Steam 创意工坊 | `"mod_<ID>:0"` | `"mod_1234567890:0"` |
| 游戏 Data 目录 | `"<文件夹名>:0"` | `"remove60ptree:0"` |

---

## 🔍 判断逻辑

### 核心代码位置
**文件：** `infrastructure/options_set_parser.py`  
**方法：** `set_mods()` (第 239-251 行)

```python
# AI-generated: Determine mod entry format based on source directory
if "workshop" in mod.folderPath.lower():
    # Steam Workshop mod: use "mod_<ID>:0" format
    mod_entry = f'\t\t"mod_{mod.id}:0"\n'
else:
    # Manual/Data directory mod: use folder name from folderPath
    # Extract folder name from path (e.g., "remove60ptree" from ".../mods/remove60ptree/mod.info")
    folder_name = Path(mod.folderPath).name
    mod_entry = f'\t\t"{folder_name}:0"\n'
```

### 判断依据
通过检查 `mod.folderPath` 是否包含 `"workshop"` 关键字：

```python
mod.folderPath = "C:/Users/.../steamapps/workshop/content/400750/1234567890"
# ↓ 包含 "workshop" → Steam 创意工坊模组

mod.folderPath = "B:/SteamLibrary/.../Call to Arms - Gates of Hell/mods/remove60ptree"
# ↓ 不包含 "workshop" → 游戏 Data 目录模组
```

---

## 📂 路径示例

### 场景 1: Steam 创意工坊模组

**模组路径：**
```
C:\Users\Username\AppData\Local\Steam\steamapps\workshop\content\400750\1234567890\mod.info
```

**Mod 对象属性：**
```python
mod.id = "1234567890"
mod.folderPath = "C:/Users/Username/.../workshop/content/400750/1234567890"
mod.manualInstall = False
```

**写入 options.set：**
```
{mods
    "mod_1234567890:0"
}
```

---

### 场景 2: 游戏 Data 目录模组

**模组路径：**
```
B:\SteamLibrary\steamapps\common\Call to Arms - Gates of Hell\mods\remove60ptree\mod.info
```

**Mod 对象属性：**
```python
mod.id = "remove60ptree"  # 文件夹名称
mod.folderPath = "B:/SteamLibrary/.../mods/remove60ptree"
mod.manualInstall = True
```

**写入 options.set：**
```
{mods
    "remove60ptree:0"
}
```

**关键点：**
- ✅ 使用文件夹名称 `remove60ptree`
- ❌ 不使用 `mod.remove60ptree`
- ✅ 格式为 `"文件夹名:0"`

---

## 🔄 读取解析逻辑

### 正则表达式更新

**文件：** `infrastructure/options_set_parser.py`  
**位置：** 第 28-34 行

```python
# AI-generated: Updated patterns to support folder names for manual mods
MOD_ENTRY_PATTERN = re.compile(r'^\s*"([^"]+):0"\s*$')  # Match any mod entry
WORKSHOP_MOD_PATTERN = re.compile(r'^\s*"mod_(\d+):0"\s*$')  # Workshop: mod_NUMBER:0
MANUAL_MOD_PATTERN = re.compile(r'^\s*"([a-zA-Z0-9_-]+):0"\s*$')  # Manual: folder_name:0
```

### 解析流程

**方法：** `get_mods()` (第 132-162 行)

```python
for line in self.lines[start_idx + 1 : end_idx]:
    # 1. 先尝试匹配 Steam 创意工坊格式
    workshop_match = self.WORKSHOP_MOD_PATTERN.match(line)
    if workshop_match:
        mods.append(workshop_match.group(1))  # 提取数字 ID
        continue

    # 2. 再尝试匹配手动模组格式（支持字母数字下划线连字符）
    manual_match = self.MANUAL_MOD_PATTERN.match(line)
    if manual_match:
        mods.append(manual_match.group(1))  # 提取文件夹名称
```

### 支持的格式

| 格式 | 正则匹配 | 提取结果 |
|------|---------|---------|
| `"mod_1234567890:0"` | WORKSHOP_MOD_PATTERN | `"1234567890"` |
| `"remove60ptree:0"` | MANUAL_MOD_PATTERN | `"remove60ptree"` |
| `"my-mod_v2:0"` | MANUAL_MOD_PATTERN | `"my-mod_v2"` |
| `"test_123:0"` | MANUAL_MOD_PATTERN | `"test_123"` |

---

## 🧪 完整示例

### options.set 文件内容

```ini
// Game settings file
{graphics
    "resolution:1920x1080"
    "fullscreen:1"
}

{mods
    "mod_2890123456:0"          ← Steam Workshop mod
    "remove60ptree:0"           ← Manual mod (Data directory)
    "mod_3456789012:0"          ← Steam Workshop mod
    "enhanced_ai:0"             ← Manual mod (Data directory)
    "mod_template:0"            ← Template (ignored)
}

{audio
    "volume:80"
}
```

### 解析结果

```python
get_mods() 返回:
[
    "2890123456",      # Steam Workshop ID
    "remove60ptree",   # Manual mod folder name
    "3456789012",      # Steam Workshop ID
    "enhanced_ai"      # Manual mod folder name
]
```

### 写入时的转换

假设有以下 Mod 对象列表：

```python
mods = [
    Mod(
        id="2890123456",
        folderPath="C:/.../workshop/content/400750/2890123456",
        ...
    ),
    Mod(
        id="remove60ptree",
        folderPath="B:/.../Gates of Hell/mods/remove60ptree",
        ...
    ),
]
```

**写入 options.set：**

```python
for mod in mods:
    if "workshop" in mod.folderPath.lower():
        # Steam Workshop → "mod_2890123456:0"
        entry = f'"mod_{mod.id}:0"'
    else:
        # Manual mod → "remove60ptree:0"
        folder_name = Path(mod.folderPath).name  # "remove60ptree"
        entry = f'"{folder_name}:0"'
```

**最终输出：**
```
{mods
    "mod_2890123456:0"
    "remove60ptree:0"
}
```

---

## ⚠️ 注意事项

### 1. 文件夹名称限制

手动模组的文件夹名称必须符合正则表达式 `[a-zA-Z0-9_-]+`：

✅ **允许的字符：**
- 字母：`a-z`, `A-Z`
- 数字：`0-9`
- 下划线：`_`
- 连字符：`-`

❌ **不允许的字符：**
- 空格
- 中文
- 特殊符号（`@`, `#`, `$`, etc.）

**示例：**
```
✅ remove60ptree
✅ my_mod_v2
✅ enhanced-ai
❌ my mod (有空格)
❌ 我的模组 (中文)
❌ mod@test (特殊符号)
```

---

### 2. 路径检测可靠性

当前使用 `"workshop" in mod.folderPath.lower()` 来判断来源。

**可能的路径：**
```
✅ C:/.../steamapps/workshop/content/400750/...  → 检测到
✅ D:/Steam/workshop/...                         → 检测到
❌ E:/Games/Gates of Hell/data/...               → 未检测到（正确）
```

**边缘情况：**
如果用户将 Steam 库安装在包含 "workshop" 的路径中但实际是手动模组，可能会误判。但这种概率极低。

---

### 3. 向后兼容性

**现有 options.set 文件：**
- ✅ 纯数字 ID 的模组（如 `"123:0"`）仍然可以正常解析
- ✅ Steam Workshop 模组（如 `"mod_123:0"`）不受影响
- ✅ 新格式的文件夹名称（如 `"remove60ptree:0"`）也能正确解析

**升级后首次运行：**
- 已有的手动模组会被重新扫描
- `folderPath` 会自动设置
- 下次保存时会使用新格式

---

## 🐛 故障排查

### Q1: 手动模组没有被识别？

**检查步骤：**
1. 确认 mod.info 文件存在
2. 确认文件夹名称只包含字母、数字、下划线、连字符
3. 确认路径不在 Steam workshop 目录中
4. 查看日志：`logs/mod_manager.log`

**常见错误：**
```
❌ B:\Mods\我的模组\mod.info     → 中文文件夹名
❌ B:\Mods\my mod\mod.info       → 含空格
✅ B:\Mods\my_mod\mod.info       → 正确
```

---

### Q2: options.set 中格式不正确？

**可能原因：**
1. `folderPath` 字段为空或错误
2. 模组是从旧版本导入的，没有正确的路径信息

**解决方案：**
1. 删除该模组
2. 重新导入
3. 点击 "Refresh" 刷新列表
4. 重新激活模组并保存

---

### Q3: 混合使用两种格式会有问题吗？

**不会！** options.set 可以同时包含两种格式：

```
{mods
    "mod_1234567890:0"      ← Steam Workshop
    "manual_mod:0"          ← Manual mod
    "mod_0987654321:0"      ← Steam Workshop
    "another_mod:0"         ← Manual mod
}
```

游戏会正确识别这两种格式。

---

## 📊 修改总结

### 修改的文件
- ✅ `infrastructure/options_set_parser.py`

### 修改的内容
1. **正则表达式更新** (第 28-34 行)
   - `MANUAL_MOD_PATTERN` 从 `\d+` 改为 `[a-zA-Z0-9_-]+`
   - 支持字母数字组合的文件夹名称

2. **写入逻辑优化** (第 239-251 行)
   - 根据 `folderPath` 判断模组来源
   - Steam Workshop → `"mod_<ID>:0"`
   - 手动模组 → `"<文件夹名>:0"`

3. **注释增强**
   - 所有关键逻辑添加 AI 生成标注
   - 详细说明判断依据和格式

### 影响范围
- ✅ 不影响现有 Steam Workshop 模组
- ✅ 兼容旧的纯数字 ID 手动模组
- ✅ 支持新的文件夹名称格式
- ✅ 向后完全兼容

---

## 🎯 测试建议

### 测试用例 1: Steam Workshop 模组
```
1. 启用一个 Steam 下载的模组
2. 检查 options.set 中的格式
预期结果: "mod_1234567890:0"
```

### 测试用例 2: 手动模组（文件夹名）
```
1. 在 data/mods/ 下创建文件夹 "test_mod"
2. 放入 mod.info
3. 在软件中刷新并启用
4. 检查 options.set
预期结果: "test_mod:0"
```

### 测试用例 3: 混合模式
```
1. 同时启用 Steam 模组和手动模组
2. 检查 options.set
预期结果: 两种格式共存
```

### 测试用例 4: 读取解析
```
1. 手动编辑 options.set，添加 "custom_mod:0"
2. 重启软件
3. 检查是否正确加载
预期结果: 模组出现在激活列表中
```

---

**最后更新：** 2026-04-15  
**相关文档：** 
- [WORKFLOW.md](WORKFLOW.md) - 完整工作流程
- [MOD_INFO_READING.md](MOD_INFO_READING.md) - mod.info 读取详解
