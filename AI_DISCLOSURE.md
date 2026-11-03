# AI 使用声明 / AI Disclosure

本文说明本项目中人工智能参与的范围、标注规则与人工验证方式。

This document describes where AI assistance was used in this project, how such code is
marked, and how it was verified.

---

## 1. 使用范围 / Scope

AI 辅助主要用于以下几类工作：

| 范围 | 说明 |
|---|---|
| 功能实现 | 模组别名系统、多编码读取、模组来源标识、本地模组支持、外部语言包加载 |
| Bug 修复 | 双击列表导致滚动条跳动、中文被 `unicode_escape` 破坏、语言代码匹配失效 |
| 文档撰写 | README、`docs` 类说明文档、变更记录 |
| 打包配置 | PyInstaller 参数与资源收集 |

上游原有代码（`alexbdka/goh-mod-manager` v1.4.2）不是 AI 生成的；AI 只参与本衍生版本新增或修改的部分。

*Upstream code is not AI-generated. AI assistance was limited to the additions and
changes introduced by this derivative version.*

## 2. 使用的工具 / Tools used

主要使用对话式 AI 编程助手（IDE 内置智能体与命令行智能体）生成初稿，由维护者提出需求、
审阅、修改并测试。

> 如需要精确到具体产品与版本，请由维护者在此补充。

## 3. 标注规则 / Marking convention

- 文件级：被整体纳入 AI 协作的文件在首个注释行写 `# AI-generated code, human reviewed`。
- 代码块级：AI 新增或修改的函数 / 语句上方写
  `# AI-generated: <这段代码做了什么>`。
- 文档级：由 AI 起草的文档在正文中注明，或在此文件中登记。

## 4. 人工验证 / Human review

每一处 AI 产出都经过以下步骤才被接受：

1. 逐行阅读 diff，确认逻辑与项目架构一致；
2. 运行 `uv run -m goh_mod_manager` 手动验证界面行为；
3. 运行 `uv run pytest` 确认既有测试未回归；
4. 对涉及文件编码、路径拼接、Qt 信号连接的改动，额外用真实 `mod.info` /
   `options.set` 样本验证。

**验证不等于保证。** 本项目为个人维护的衍生版本，AI 生成的代码可能存在
边界情况处理不当或与上游行为不一致的问题。使用前请自行评估风险，尤其是涉及
`options.set` 写回的操作 —— 建议先备份该文件。

## 5. 已知局限 / Known limitations

- 中文翻译目前覆盖 6 个界面上下文（主窗口、主对话框、偏好设置等），
  控制器与部分视图中的字符串仍为英文；欢迎补充。
- 上游英文语言源文件（`goh_mod_manager_en.qm`）曾存在损坏，已移除；
  英文界面直接使用代码中的源字符串，不需要语言包。

## 6. 反馈 / Feedback

如果发现某段代码行为异常且带有 `# AI-generated:` 标记，请优先怀疑该处逻辑，
并在提交 Issue / Pull Request 时指出对应标记。
