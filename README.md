# Autonomous Coding Agent Harness

基于 Anthropic 的 "Effective harnesses for long-running agents" 方法构建的自动开发框架。

## 架构概览

```
auto-agent/
├── CLAUDE.md                 # 项目说明
├── harness/
│   ├── init.sh               # 初始化脚本（开发服务器启动）
│   ├── prompts/
│   │   ├── initializer.md     # 初始化 Agent prompt
│   │   └── coding.md         # 编码 Agent prompt
│   └── scripts/
│       ├── start-session.sh  # 会话启动脚本
│       ├── end-session.sh    # 会话结束脚本
│       └── run-e2e-test.sh  # E2E 测试脚本
├── feature_list.json         # 特性列表（初始化时生成）
├── claude-progress.txt       # 进度日志
└── README.md
```

## 核心概念

### 1. 双 Agent 设计

- **Initializer Agent**: 首次运行时设置环境，生成 feature_list.json、init.sh、初始 git 提交
- **Coding Agent**: 每次会话增量开发，一次只做一个特性，结束时保持代码库处于可合并状态

### 2. 环境管理

- `feature_list.json`: 完整的特性清单，每个特性有 passes 状态
- `claude-progress.txt`: 进度日志，记录已完成的 work
- `init.sh`: 开发服务器启动脚本
- Git 历史用于恢复和理解上下文

### 3. 会话流程

**会话开始**:
1. 运行 `pwd` 查看工作目录
2. 读取 `git log` 和 `claude-progress.txt` 了解最近 work
3. 读取 `feature_list.json` 选择最高优先级的未完成特性
4. 运行 `init.sh` 启动开发服务器
5. E2E 测试验证基础功能正常

**会话进行**:
- 一次只做一个特性
- 充分测试后更新 feature_list.json 中的 passes 状态

**会话结束**:
- 编写描述性 git commit
- 更新 claude-progress.txt

## 使用方法

### 首次启动

```bash
# 设置项目
./harness/scripts/init-project.sh "项目描述"
```

### 开发循环

```bash
# 开始编码会话
./harness/scripts/start-session.sh

# (Agent 完成后)

# 结束会话
./harness/scripts/end-session.sh
```

## 特性列表格式

```json
{
  "features": [
    {
      "id": "feat-001",
      "category": "functional",
      "description": "New chat button creates a fresh conversation",
      "steps": [
        "Navigate to main interface",
        "Click the 'New Chat' button",
        "Verify a new conversation is created",
        "Check that chat area shows welcome state",
        "Verify conversation appears in sidebar"
      ],
      "priority": "high",
      "passes": false
    }
  ]
}
```

## 失败模式与解决方案

| 问题 | Initializer Agent | Coding Agent |
|------|-------------------|---------------|
| Agent 过早宣布完成 | 生成完整的 feature_list.json | 读取特性列表，一次做一个 |
| 代码处于 bug 状态 | 创建 git 仓库和 progress 文件 | 读取 progress 和 git log，测试基础功能后再开始 |
| 特性标记为完成但实际未完成 | 设置 feature_list.json | 所有特性需通过 E2E 测试才标记为 passes |
| Agent 需要花时间了解如何运行应用 | 编写 init.sh | 读取 init.sh 启动开发服务器 |

## 测试策略

使用 Puppeteer MCP 进行浏览器自动化测试。Agent 被明确要求像真实用户一样测试所有功能。

测试优先级:
1. 视觉回归测试 - 关键断点截图
2. 可访问性测试 - 键盘导航、颜色对比
3. 功能测试 - 端到端用户流程

## 设计原则

1. **增量开发**: 一次只做一个特性，避免上下文溢出
2. **清洁状态**: 每次会话结束时代码库处于可合并状态
3. **可恢复**: Git 历史 + progress 文件 = 完整上下文
4. **自我验证**: 特性必须通过测试才能标记为完成

## 扩展方向

- 多 Agent 架构: 测试 Agent、QA Agent、代码清理 Agent
- 其他领域: 科学研究、金融建模等长时任务