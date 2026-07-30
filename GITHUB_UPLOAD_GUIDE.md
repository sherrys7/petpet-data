# 📤 GitHub Web 上传指南

## 待上传文件

所有文件已准备在：`/workspace/data/moe.d2n.petpet-js/beat_up/`

- `0.png` (73KB)
- `1.png` (75KB)
- `2.png` (73KB)
- `data.json` (1.1KB)

---

## 📋 上传步骤

### 第 1 步：创建 GitHub 仓库

1. 访问：**https://github.com/new**
2. 填写信息：
   - **Repository name**: `petpet-data`
   - **Description**: `Templates for petpet-js`
   - 选择 **Public**（公开）
3. 点击 **Create repository**

---

### 第 2 步：上传文件

在新创建的仓库页面：

1. 点击 **uploading an existing file** 链接

2. 将以下 4 个文件拖拽到上传区域：
   - `0.png`
   - `1.png`
   - `2.png`
   - `data.json`

3. 在 **Commit changes** 输入框中填写：
   ```
   feat: add beat_up template
   ```

4. 点击 **Commit changes** 按钮

---

### 第 3 步：创建目录结构

仓库创建好后，需要将文件放到正确的目录：

1. 在仓库页面点击 **Add file** → **Create new file**

2. 在文件名输入框中输入：
   ```
   data/beat_up/.gitkeep
   ```

3. 这个文件内容可以留空，点击 **Commit new file**

4. 然后上传文件到正确位置：
   - 点击 **Add file** → **Upload files**
   - 将 4 个文件拖入
   - 修改文件路径为：`data/beat_up/0.png`、`data/beat_up/1.png`、`data/beat_up/2.png`、`data/beat_up/data.json`
   - 点击 **Commit changes**

---

### 第 4 步：启用 GitHub Pages

1. 进入仓库的 **Settings** 标签页

2. 左侧菜单找到 **Pages**

3. 在 **Build and deployment** 部分：
   - **Source**: 选择 `Deploy from a branch`
   - **Branch**: 选择 `main`
   - **Folder**: 选择 `/ (root)`
   - 点击 **Save**

4. 等待 2-3 分钟，页面会显示：
   ```
   Your site is live at https://你的用户名.github.io/petpet-data/
   ```

---

### 第 5 步：访问你的模板

访问地址：
```
https://你的用户名.github.io/petpet-data/?template=beat_up
```

---

## 🔍 验证

访问后应该能看到：
- ✅ 网页正常加载
- ✅ 可以上传头像图片
- ✅ 生成的 GIF 有 3 帧动画效果
- ✅ 两个头像都是圆形剪裁

---

## 💡 提示

- 如果 Pages 页面长时间未生成，检查 **Settings → Pages** 是否有错误信息
- GitHub Pages 首次部署可能需要 5-10 分钟
- 如果遇到问题，可以查看 **Settings → Pages → GitHub Actions logs**

---

## 🎯 完成后的效果

模板 `beat_up` 的特性：
- 3 帧 GIF 动画
- 两个圆形头像（FROM 和 TO）
- 适合制作互动表情包
