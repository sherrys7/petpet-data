# 🚀 Beat Up 模板部署完成指南

## ✅ 已完成的工作

1. ✅ 模板配置文件已创建：`/workspace/data/moe.d2n.petpet-js/beat_up/data.json`
2. ✅ GIF 已拆分为 3 帧图片：
   - `0.png` (73KB)
   - `1.png` (75KB)
   - `2.png` (73KB)

## 📋 待完成的部署步骤

由于 GitHub 认证需要交互操作，请按以下步骤手动完成部署：

### 方案 A：使用 GitHub Web 界面（最简单）

#### 步骤 1：创建 GitHub 仓库

1. 访问 https://github.com/new
2. Repository name: `petpet-data`
3. 选择 **Public**
4. 点击 **Create repository**

#### 步骤 2：上传文件

1. 在新创建的仓库页面，点击 **"uploading an existing file"**
2. 将以下文件拖拽到上传区域：
   ```
   /workspace/data/moe.d2n.petpet-js/beat_up/0.png
   /workspace/data/moe.d2n.petpet-js/beat_up/1.png
   /workspace/data/moe.d2n.petpet-js/beat_up/2.png
   /workspace/data/moe.d2n.petpet-js/beat_up/data.json
   ```
3. 在 "**Commit changes**" 框中输入：`feat: add beat_up template`
4. 点击 **Commit changes**

#### 步骤 3：启用 GitHub Pages

1. 进入仓库的 **Settings** → **Pages**
2. Source 选择：**Deploy from a branch**
3. Branch 选择：**main**，folder 选择：**/(root)**
4. 点击 **Save**
5. 等待几分钟后，页面会显示访问地址

#### 步骤 4：访问模板

访问地址格式：
```
https://你的用户名.github.io/petpet-data/?template=beat_up
```

---

### 方案 B：使用 GitHub CLI（自动化）

如果你有 sudo 权限，可以执行以下命令：

```bash
# 1. 登录 GitHub
gh auth login

# 2. 配置 Git 用户信息
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"

# 3. 获取用户名
USERNAME=$(gh api user | jq -r '.login')
echo "用户名：$USERNAME"

# 4. 创建临时目录并克隆
cd /workspace/data/moe.d2n.petpet-js/beat_up
rm -rf /tmp/petpet-deploy
mkdir /tmp/petpet-deploy
cd /tmp/petpet-deploy
git init

# 5. 复制文件
cp /workspace/data/moe.d2n.petpet-js/beat_up/*.png .
cp /workspace/data/moe.d2n.petpet-js/beat_up/data.json .

# 6. 创建并推送
git add .
git commit -m "feat: add beat_up template"
git branch -M main
gh repo create petpet-data --public --source . --push

echo "✅ 部署完成！"
echo "访问地址：https://$USERNAME.github.io/petpet-data/?template=beat_up"
```

---

### 方案 C：使用在线编辑器上传

1. 访问 https://dituon.github.io/petpet-js/editor/index.html
2. 登录 GitHub 账户
3. 上传拆分好的 PNG 文件和 data.json
4. 点击上传按钮

---

## 📊 模板信息总结

**模板名称**: `beat_up`

**配置内容**:
```json
{
  "type": "GIF",
  "avatar": [
    {
      "type": "FROM",
      "pos": [[99,40,59,59], [109,45,59,59], [100,40,59,59]],
      "round": true
    },
    {
      "type": "TO", 
      "pos": [[98,136,45,45], [99,137,45,45], [89,140,45,45]],
      "round": true
    }
  ],
  "text": []
}
```

**特点**:
- 3 帧动画
- 两个圆形头像（FROM 和 TO）
- 无文字

---

## 🎯 验证部署

部署完成后，访问：
```
https://你的用户名.github.io/petpet-data/?template=beat_up
```

应该能看到：
1. 网页加载正常
2. 可以选择上传头像
3. 生成的 GIF 动画有 3 帧效果

---

## 📝 文件清单

所有必需文件已准备在：
```
/workspace/data/moe.d2n.petpet-js/beat_up/
├── 0.png          ✅ 73KB
├── 1.png          ✅ 75KB  
├── 2.png          ✅ 73KB
├── data.json      ✅ 1.1KB
└── background.gif ✅ 102KB (原始文件，可选)
```

选择任一部署方案完成最后的上传步骤即可！
