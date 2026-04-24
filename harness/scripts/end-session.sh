#!/bin/bash
# end-session.sh - 会话结束脚本

set -e

echo "========================================="
echo "🔚 Ending Coding Session"
echo "========================================="

# 1. 确认 git 状态
echo -e "\n📊 Git status:"
git status --short 2>/dev/null || echo "Not a git repository"

# 2. 变更统计
echo -e "\n📈 Change statistics:"
if [ -d ".git" ]; then
    git diff --stat HEAD 2>/dev/null || true
fi

# 3. 更新进度文件
echo -e "\n📝 Updating progress file..."
if [ -f "claude-progress.txt" ]; then
    echo "" >> claude-progress.txt
    echo "=== Session $(date '+%Y-%m-%d %H:%M') ===" >> claude-progress.txt
    echo "Files modified:" >> claude-progress.txt
    git diff --name-only HEAD 2>/dev/null | sed 's/^/  - /' >> claude-progress.txt || true
fi

# 4. 提交变更
echo -e "\n💾 Committing changes..."
read -p "Enter commit message (or press Enter for default): " commit_msg

if [ -n "$commit_msg" ]; then
    git add -A
    git commit -m "$commit_msg"
    echo "✅ Changes committed: $commit_msg"
else
    echo "⏭️ Skipping commit (no message provided)"
fi

# 5. 最终状态
echo -e "\n========================================="
echo "✅ Session ended"
echo "========================================="