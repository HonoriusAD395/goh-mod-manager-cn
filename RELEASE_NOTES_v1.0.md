# GoH Mod Manager v1.0 发布说明

**发布日期**: 2026-04-16  
**版本**: v1.0  
**可执行文件**: `GoH_Mod_Manager_v1.0.exe`  
**文件大小**: ~49 MB

---

## 📦 可执行文件信息

### 文件位置
```
B:\Work\python\goh-mod-manager-cn\dist\GoH_Mod_Manager_v1.0.exe
```

### 技术规格
- **打包工具**: PyInstaller 6.19.0
- **Python 版本**: 3.14.2
- **UI 框架**: PySide6 (Qt for Python)
- **架构**: Windows 64-bit
- **压缩**: UPX 压缩启用
- **控制台**: 无（GUI 应用程序）

---

## ✨ v1.0 新功能

### 1. 模组来源标注功能
- ✅ **图标区分**: 
  - 🎮 = Steam Workshop 模组
  - 📦 = 本地模组
- ✅ **悬停提示**: 鼠标悬停显示详细信息
  - Steam Workshop: 显示模组 ID 和名称
  - 本地模组: 显示文件夹名和名称

### 2. 双击跳转 Bug 修复
- ✅ 修复了 Installed Mods 列表双击时滚动条跳转到顶部的问题
- ✅ 禁用了列表项的编辑功能，提升用户体验

### 3. 代码质量改进
- ✅ 所有代码修改添加 `# AI-generated: [description]` 标注
- ✅ 优化路径判断逻辑，避免 Python 缓存问题
- ✅ 添加详细的调试日志输出

---

## 🔧 已知问题

### 已修复
- ✅ NameError: Path 未定义（通过清除缓存解决）
- ✅ 所有模组被错误识别为创意工坊模组
- ✅ 无法添加模组到 Active Mods
- ✅ 双击列表项导致滚动跳转

### 待观察
- 暂无已知问题

---

## 📋 系统要求

### 最低配置
- **操作系统**: Windows 10 或更高版本
- **内存**: 2 GB RAM
- **磁盘空间**: 100 MB 可用空间
- **游戏**: Call to Arms - Gates of Hell（用于读取模组）

### 推荐配置
- **操作系统**: Windows 10/11 64-bit
- **内存**: 4 GB RAM
- **磁盘空间**: 500 MB 可用空间

---

## 🚀 使用方法

### 首次运行
1. 双击 `GoH_Mod_Manager_v1.0.exe`
2. 程序会自动扫描以下位置的模组：
   - Steam Workshop: `steamapps/workshop/content/...`
   - 本地模组: `Call to Arms - Gates of Hell/mods/...`
   - Data 目录模组: `Call to Arms - Gates of Hell/data/...`

### 基本操作
1. **激活模组**: 
   - 在左侧 Installed Mods 中选择模组
   - 点击 "Activate" 按钮添加到右侧 Active Mods
   
2. **调整顺序**:
   - 在 Active Mods 列表中拖拽模组调整加载顺序
   
3. **停用模组**:
   - 在右侧 Active Mods 中选择模组
   - 点击 "Deactivate" 按钮移除

4. **查看模组详情**:
   - 鼠标悬停在模组上查看来源和详细信息
   - 左侧面板显示模组的完整描述

---

## 📁 分发说明

### 单文件分发
当前版本为**单文件可执行程序**，可以直接分发 `GoH_Mod_Manager_v1.0.exe` 文件。

### 优点
- ✅ 只需一个 .exe 文件
- ✅ 无需安装 Python 环境
- ✅ 便于分享和部署

### 注意事项
- ⚠️ 首次启动可能较慢（需要解压临时文件）
- ⚠️ 杀毒软件可能误报（PyInstaller 打包的常见问题）
- ⚠️ 确保目标系统有必要的 Visual C++ 运行库

---

## 🔍 故障排除

### 程序无法启动
1. 检查是否有杀毒软件阻止
2. 以管理员身份运行
3. 确保安装了最新的 Visual C++ Redistributable

### 模组未检测到
1. 确认游戏安装路径正确
2. 检查模组文件夹权限
3. 查看日志文件（如果生成）

### 界面显示异常
1. 更新显卡驱动
2. 尝试兼容性模式运行
3. 检查 DPI 缩放设置

---

## 📝 构建信息

### 打包命令
```bash
cd B:\Work\python\goh-mod-manager-cn
python -m PyInstaller --clean build_executable.spec
```

### 配置文件
- **Spec 文件**: `build_executable.spec`
- **构建脚本**: `build.bat`

### 包含的资源
- UI 界面文件（.ui）
- 图标资源（.ico, .png）
- 翻译文件（i18n）
- 所有 Python 模块

---

## 🎯 后续计划

### v1.1 计划功能
- [ ] 模组搜索和过滤
- [ ] 模组依赖关系检查
- [ ] 自动更新检测
- [ ] 模组预设配置保存/加载
- [ ] 批量操作支持

### v1.2 计划功能
- [ ] 模组冲突检测
- [ ] 性能分析工具
- [ ] 自定义主题支持
- [ ] 插件系统

---

## 📞 支持与反馈

### 问题报告
如遇到问题，请提供：
1. 操作系统版本
2. 游戏安装路径
3. 错误截图或日志
4. 复现步骤

### 功能建议
欢迎提出新功能建议和改进意见！

---

## 📄 许可证

本项目基于原始 GoH Mod Manager 项目进行二次开发。

---

## 🙏 致谢

感谢所有测试者和贡献者！

特别感谢：
- PyInstaller 团队
- PySide6/Qt 开发团队
- 原始 GoH Mod Manager 开发者

---

**构建完成时间**: 2026-04-16 22:09:40  
**构建状态**: ✅ 成功  
**文档版本**: 1.0
