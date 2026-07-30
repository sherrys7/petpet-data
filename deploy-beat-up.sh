#!/bin/bash
# petpet-js 模板自动部署脚本
# 自动将 beat_up 模板上传到 GitHub

set -e

TEMPLATE_DIR="/workspace/data/moe.d2n.petpet-js/beat_up"
TEMPLATE_NAME="beat_up"

echo "🎨 Petpet-js 模板部署工具"
echo "========================="
echo ""

cd "$TEMPLATE_DIR"

# 检查必要工具
echo "📋 检查必要工具..."
if ! command -v gh &> /dev/null; then
    echo "❌ 错误：需要安装 GitHub CLI"
    echo "安装地址：https://cli.github.com/"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "❌ 错误：需要安装 jq"
    echo "安装命令：apt-get install jq"
    exit 1
fi

echo "✅ 必要工具已安装"
echo ""

# GitHub 登录
echo "🔐 GitHub 登录..."
if ! gh auth status &> /dev/null; then
    echo "需要登录 GitHub，请使用以下命令："
    echo "  gh auth login"
    echo ""
    read -p "已完成登录？(y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "✅ GitHub 已登录"
echo ""

# 获取用户名
echo "👤 获取 GitHub 用户名..."
USERNAME=$(gh api user | jq -r '.login')
echo "用户名：$USERNAME"
echo ""

# 创建/更新仓库
REPO_DIR="/tmp/petpet-data-$USERNAME"
echo "📦 准备仓库..."

if [ -d "$REPO_DIR" ]; then
    rm -rf "$REPO_DIR"
fi

# 检查仓库是否存在
if gh repo view "$USERNAME/petpet-data" &> /dev/null; then
    echo "仓库已存在，克隆中..."
    git clone "https://github.com/$USERNAME/petpet-data.git" "$REPO_DIR"
    cd "$REPO_DIR"
else
    echo "创建新仓库..."
    mkdir -p "$REPO_DIR"
    cd "$REPO_DIR"
    git init
    git remote add origin "https://github.com/$USERNAME/petpet-data.git"
fi

# 复制模板文件
echo ""
echo "📁 复制模板文件..."
mkdir -p "data/$TEMPLATE_NAME"
cp "$TEMPLATE_DIR"/*.png "data/$TEMPLATE_NAME/"
cp "$TEMPLATE_DIR/data.json" "data/$TEMPLATE_NAME/"

# 创建 README
cat > README.md << EOF
# Petpet Data

 Templates for petpet-js

## Usage

Visit: https://$USERNAME.github.io/petpet-data/?template=$TEMPLATE_NAME

## Templates

- $TEMPLATE_NAME: Custom template
EOF

# Git 提交
echo ""
echo "💾 提交更改..."
git add .
git commit -m "feat: add $TEMPLATE_NAME template" || echo "没有更改需要提交"

# 推送
echo ""
echo "🚀 推送到 GitHub..."
git branch -M main 2>/dev/null || true
git push -u origin main

echo ""
echo "🎉 部署完成！"
echo ""
echo "========================="
echo "📱 访问地址:"
echo "  https://$USERNAME.github.io/petpet-data/?template=$TEMPLATE_NAME"
echo ""
echo "🔗 仓库地址:"
echo "  https://github.com/$USERNAME/petpet-data"
echo ""
echo "⚙️  如果页面无法访问，请启用 GitHub Pages:"
echo "  1. 访问 https://github.com/$USERNAME/petpet-data/settings/pages"
echo "  2. Source 选择 'Deploy from a branch'"
echo "  3. Branch 选择 'main', folder 选择 '/ (root)'"
echo "  4. 点击 Save"
echo ""
