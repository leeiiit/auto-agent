#!/bin/bash
# init-project.sh - 项目初始化脚本

set -e

PROJECT_DESC="${1:-}"

if [ -z "$PROJECT_DESC" ]; then
    echo "❌ Please provide a project description"
    echo "Usage: ./harness/scripts/init-project.sh \"项目描述\""
    exit 1
fi

echo "========================================="
echo "🚀 Initializing New Project"
echo "========================================="

echo -e "\n📋 Project: $PROJECT_DESC"

# 创建 feature_list.json
# 创建 SPEC.md (产品需求文档)
echo -e "\n📄 Creating SPEC.md (Product Requirements Document)..."
cat > SPEC.md << 'EOF'
# 产品需求文档 (PRD)

# 产品概述

**项目名称**: PROJECT_NAME
**版本**: 1.0.0
**创建日期**: DATE_PLACEHOLDER

## 1. 产品愿景

[描述产品要解决的核心问题和价值]

## 2. 用户故事

### 目标用户

[描述主要用户群体]

### 核心用户故事

1. **作为** [用户类型]，**我希望** [功能]，**以便** [收益]
2. **作为** [用户类型]，**我希望** [功能]，**以便** [收益]

## 3. 功能需求

### P0 - 核心功能

| 功能 | 描述 |
|------|------|
| [功能1] | [描述] |
| [功能2] | [描述] |

### P1 - 重要功能

| 功能 | 描述 |
|------|------|
| [功能1] | [描述] |

## 4. 非功能需求

- 性能: [要求]
- 安全: [要求]
- 兼容性: [要求]

## 5. 技术约束

[技术栈/约束]

## 6. 产品路线图

### Phase 1 - MVP
- [ ] [功能]

### Phase 2 - 增强
- [ ] [功能]

EOF

sed -i '' "s/PROJECT_NAME/$PROJECT_DESC/g" SPEC.md
sed -i '' "s/DATE_PLACEHOLDER/$(date '+%Y-%m-%d')/g" SPEC.md

# 创建 feature_list.json
echo -e "\n📦 Creating feature list..."
cat > feature_list.json << 'EOF'
{
  "project": "TBD",
  "description": "PROJECT_DESC_PLACEHOLDER",
  "features": [],
  "created": "ISO_DATE_PLACEHOLDER"
}
EOF

sed -i '' "s/PROJECT_DESC_PLACEHOLDER/$PROJECT_DESC/g" feature_list.json
sed -i '' "s/ISO_DATE_PLACEHOLDER/$(date -u +%Y-%m-%dT%H:%M:%SZ)/g" feature_list.json

# 初始化 Git
echo -e "\n📜 Initializing git repository..."
git init
git add -A
git commit -m "Initial commit: project foundation with SPEC.md"

# 创建进度文件
echo -e "\n📝 Creating progress file..."
cat > claude-progress.txt << 'EOF'
=== Project Initialization ===
Project: PROJECT_NAME
Started: DATE_PLACEHOLDER

Status: Environment ready for development
EOF

sed -i '' "s/PROJECT_NAME/$PROJECT_DESC/g" claude-progress.txt
sed -i '' "s/DATE_PLACEHOLDER/$(date '+%Y-%m-%d %H:%M')/g" claude-progress.txt

# 创建 init.sh
echo -e "\n🚀 Creating init.sh..."
cp harness/scripts/init.sh ./init.sh 2>/dev/null || echo "# Add your init script here" > init.sh

echo -e "\n========================================="
echo "✅ Project initialized successfully!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Edit feature_list.json with your features"
echo "2. Run ./harness/scripts/start-session.sh to begin coding"
echo ""