#!/bin/bash

# Petpet-js 模板部署脚本
# 用于将模板上传到 GitHub

set -e

TEMPLATE_NAME="beat_up"
TEMPLATE_DIR="/workspace/data/moe.d2n.petpet-js/$TEMPLATE_NAME"
GIF_FILE="$TEMPLATE_DIR/background.gif"

echo "🎨 Petpet-js 模板部署工具"
echo "========================"
echo ""

# 检查 GitHub CLI 是否安装
if ! command -v gh &> /dev/null; then
    echo "❌ 错误：需要安装 GitHub CLI (gh)"
    echo "安装方法：https://cli.github.com/"
    exit 1
fi

# 检查登录状态
echo "📝 检查 GitHub 登录状态..."
if ! gh auth status &> /dev/null; then
    echo "⚠️  未登录 GitHub，请先登录："
    gh auth login
fi

echo "✅ GitHub 登录成功"
echo ""

# 获取用户名
USERNAME=$(gh api user | jq -r '.login')
echo "👤 当前用户：$USERNAME"

# 创建临时工作目录
WORK_DIR=$(mktemp -d)
echo "📁 临时工作目录：$WORK_DIR"

# 检查是否需要拆分 GIF
if [ -f "$GIF_FILE" ]; then
    echo "🎬 检测到 GIF 文件，正在拆分成帧..."
    
    # 检查是否安装了 ImageMagick
    if command -v convert &> /dev/null; then
        cd "$WORK_DIR"
        convert "$GIF_FILE" -coalesce frame_%d.png
        
        # 重命名为 0.png, 1.png, 2.png...
        i=0
        for frame in frame_*.png; do
            mv "$frame" "$i.png"
            ((i++))
        done
        
        echo "✅ 拆分完成，共 $i 帧"
        FRAME_COUNT=$i
    else
        echo "⚠️  未安装 ImageMagick，无法自动拆分 GIF"
        echo "请手动安装：sudo apt-get install imagemagick"
        echo ""
        echo "或者手动上传 GIF 到在线编辑器进行拆分："
        echo "https://dituon.github.io/petpet-js/editor/index.html"
        exit 1
    fi
fi

# 复制 data.json
cp "$TEMPLATE_DIR/data.json" "$WORK_DIR/"

# 检查仓库是否存在
REPO_NAME="petpet-data"
FULL_NAME="$USERNAME/$REPO_NAME"

echo ""
echo "📦 检查仓库 $FULL_NAME..."

if ! gh repo view "$FULL_NAME" &> /dev/null; then
    echo "🆕 创建新仓库..."
    gh repo create "$REPO_NAME" --public --source=. --push
    
    # 创建初始提交
    cd "$WORK_DIR"
    git init
    git add .
    git commit -m "feat: add $TEMPLATE_NAME template"
    git branch -M main
    
    # 推送到 GitHub
    git remote add origin "https://github.com/$USERNAME/$REPO_NAME.git"
    git push -u origin main
else
    echo "✅ 仓库已存在"
    
    # 克隆现有仓库
    cd "$WORK_DIR"
    git clone "https://github.com/$USERNAME/$REPO_NAME.git" data
    cd data
    
    # 更新模板文件
    mkdir -p "data/$TEMPLATE_NAME"
    cp "$WORK_DIR"/* "data/$TEMPLATE_NAME/"
    
    # 提交更改
    git add "data/$TEMPLATE_NAME"
    git commit -m "feat: add $TEMPLATE_NAME template" || echo "无更改"
    
    # 推送
    git push
fi

echo ""
echo "🎉 部署完成！"
echo ""
echo "📱 使用方式："
echo "   在线预览：https://$USERNAME.github.io/$REPO_NAME/?template=$TEMPLATE_NAME"
echo ""
echo "🔗 仓库地址：https://github.com/$USERNAME/$REPO_NAME"
echo ""

# 清理
rm -rf "$WORK_DIR"
