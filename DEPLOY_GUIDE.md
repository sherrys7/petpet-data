# Beat Up 模板部署指南

## ✅ 已完成

模板文件已准备就绪：
- `/workspace/data/moe.d2n.petpet-js/beat_up/data.json` - 模板定义
- `/workspace/data/moe.d2n.petpet-js/beat_up/background.gif` - 原始 GIF

## 📦 已拆分的帧文件

临时目录中的文件（需要先拆分 GIF）：
```python
# 执行拆分
python3 << 'PYTHON'
from PIL import Image
gif = Image.open('/workspace/data/moe.d2n.petpet-js/beat_up/background.gif')
i = 0
while True:
    try:
        frame = gif.copy()
        frame.save(f'/workspace/data/moe.d2n.petpet-js/beat_up/{i}.png', 'PNG')
        i += 1
        gif.seek(gif.tell() + 1)
    except EOFError:
        break
print(f'拆分完成，共 {i} 帧')
PYTHON
```

## 🚀 部署步骤

### 步骤 1: 登录 GitHub

```bash
gh auth login
```

### 步骤 2: 创建部署脚本并执行

```bash
#!/bin/bash
cd /workspace/data/moe.d2n.petpet-js/beat_up

# 1. 拆分 GIF (如果还没有拆分)
if [ ! -f "0.png" ]; then
    python3 << 'PYTHON'
from PIL import Image
gif = Image.open('background.gif')
i = 0
while True:
    try:
        frame = gif.copy()
        frame.save(f'{i}.png', 'PNG')
        i += 1
        gif.seek(gif.tell() + 1)
    except EOFError:
        break
print(f'拆分完成，共 {i} 帧')
PYTHON
fi

# 2. 获取用户名
USERNAME=$(gh api user | jq -r '.login')
echo "用户名：$USERNAME"

# 3. 创建 GitHub 仓库
gh repo create petpet-data --public --source . --push
```

### 步骤 3: 在线访问

部署成功后访问：
```
https://你的用户名.github.io/petpet-data/?template=beat_up
```

## 🔧 手动部署（备用方案）

如果自动部署失败，可以手动操作：

1. **拆分 GIF**:
   - 访问 https://ezgif.com/split
   - 上传 `background.gif`
   - 下载所有帧，重命名为 `0.png`, `1.png`, `2.png`

2. **上传到 GitHub**:
   - 访问 https://github.com/new
   - 创建仓库名为 `petpet-data`
   - 上传所有文件到 `data/beat_up/` 目录

3. **启用 GitHub Pages**:
   - Settings → Pages
   - Source: Deploy from branch `main`, folder `/ (root)`
   - Save

## 📝 模板信息

- 名称：beat_up
- 类型：GIF 动画
- 帧数：3 帧
- 头像配置：
  - FROM: 圆形头像，3 帧动画
  - TO: 圆形头像，3 帧动画
