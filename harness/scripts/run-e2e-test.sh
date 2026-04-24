#!/bin/bash
# run-e2e-test.sh - E2E 测试脚本

set -e

echo "========================================="
echo "🧪 Running E2E Tests"
echo "========================================="

# 检查是否有测试配置
if [ -f "playwright.config.ts" ] || [ -f "playwright.config.js" ]; then
    echo "📦 Playwright detected"
    npx playwright test
elif [ -f "cypress.config.js" ]; then
    echo "📦 Cypress detected"
    npx cypress run
elif [ -f "package.json" ] && grep -q "test" package.json; then
    echo "📦 Running npm test"
    npm test
else
    echo "⚠️ No E2E test framework detected"
    echo "Please ensure one of: Playwright, Cypress, or npm test"
fi

echo -e "\n========================================="
echo "✅ E2E tests completed"
echo "========================================="