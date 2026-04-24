#!/bin/bash
# start-session.sh - 会话启动脚本

set -e

echo "========================================="
echo "🔄 Starting New Coding Session"
echo "========================================="

# 1. 查看当前目录
echo -e "\n📍 Current directory:"
pwd

# 2. 读取进度文件
echo -e "\n📋 Progress summary:"
if [ -f "claude-progress.txt" ]; then
    tail -20 claude-progress.txt
else
    echo "No progress file found. This appears to be a new project."
fi

# 3. 查看 Git 历史
echo -e "\n📜 Recent commits:"
if [ -d ".git" ]; then
    git log --oneline -10 2>/dev/null || echo "No git history"
else
    echo "No git repository initialized"
fi

# 4. 查看特性列表
echo -e "\n📦 Feature list status:"
if [ -f "feature_list.json" ]; then
    total=$(grep -c '"id":' feature_list.json 2>/dev/null || echo "0")
    passing=$(grep -c '"passes": true' feature_list.json 2>/dev/null || echo "0")
    echo "Total: $total | Completed: $passing | Remaining: $((total - passing))"
else
    echo "No feature list found"
fi

# 5. 启动开发服务器
echo -e "\n🚀 Starting development server..."
if [ -f "harness/scripts/init.sh" ]; then
    bash harness/scripts/init.sh
elif [ -f "init.sh" ]; then
    bash init.sh
else
    echo "⚠️ No init.sh found. Please ensure your project has a server start script."
fi

echo -e "\n========================================="
echo "✅ Session ready for coding"
echo "========================================="