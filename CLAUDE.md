# Auto-Agent: 长时运行 Agent 框架

基于 [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) 方法构建。

## 核心架构

**双 Agent 设计**:
1. **Initializer Agent**: 首次运行，设置完整环境
2. **Coding Agent**: 增量开发，一次一个特性

## 关键文件

| 文件 | 用途 |
|------|------|
| `feature_list.json` | 所有特性清单，passes 状态追踪 |
| `claude-progress.txt` | 会话进度日志 |
| `init.sh` | 开发服务器启动脚本 |
| `harness/prompts/` | Agent 提示词 |

## 开发流程

### 新项目
```bash
./harness/scripts/init-project.sh "项目描述"
```

### 编码会话
```bash
# 开始
./harness/scripts/start-session.sh

# 结束
./harness/scripts/end-session.sh
```

## 设计原则

1. **增量开发**: 一次只做一个特性，避免上下溢出
2. **清洁状态**: 会话结束时代码可合并
3. **可恢复**: Git + progress 文件 = 完整上下文
4. **自我验证**: E2E 测试通过才标记 passes

## 扩展方向

- 多 Agent 架构 (测试、QA、代码清理)
- 其他领域 (科研、金融建模)