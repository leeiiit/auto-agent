#!/bin/bash
# Init.sh - 开发服务器启动脚本

set -e

echo "🚀 Starting development server..."

# 检测项目类型并启动
if [ -f "package.json" ]; then
    echo "📦 Node.js project detected"
    if [ -f "pnpm-lock.yaml" ]; then
        pnpm dev &
    elif [ -f "yarn.lock" ]; then
        yarn dev &
    elif [ -f "package-lock.json" ]; then
        npm run dev &
    else
        npm install && npm run dev &
    fi
elif [ -f "Cargo.toml" ]; then
    echo "🦀 Rust project detected"
    cargo run &
elif [ -f "go.mod" ]; then
    echo "🐹 Go project detected"
    go run . &
elif [ -f "pom.xml" ]; then
    echo "☕ Java project detected"
    mvn spring-boot:run &
else
    echo "⚠️ Unknown project type, checking for common patterns..."
    if [ -f "Makefile" ]; then
        make dev &
    elif [ -f "Dockerfile" ]; then
        docker-compose up &
    fi
fi

# 等待服务器启动
echo "⏳ Waiting for server to start..."
sleep 5

# 验证服务器运行
if curl -s http://localhost:3000 > /dev/null 2>&1 || curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "✅ Server is running"
else
    echo "⚠️ Server may still be starting, checking in background..."
fi

echo "🎉 Development server started"