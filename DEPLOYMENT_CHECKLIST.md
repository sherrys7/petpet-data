# ✅ 部署验证清单

## 请检查以下项目

### 1️⃣ 检查 GitHub 仓库

访问：`https://github.com/你的用户名/petpet-data`

✅ 应该看到：
- [ ] 4 个文件已上传（0.png, 1.png, 2.png, data.json）
- [ ] 文件在正确的目录（`data/beat_up/`）
- [ ] Commit 记录显示 "feat: add beat_up template"

---

### 2️⃣ 检查 GitHub Pages

访问：`https://github.com/你的用户名/petpet-data/settings/pages`

✅ 应该显示：
- [ ] Status: **Your site is live**
- [ ] URL: `https://你的用户名.github.io/petpet-data/`

---

### 3️⃣ 访问主页面

访问：`https://你的用户名.github.io/petpet-data/`

✅ 应该看到：
- [ ] 页面正常加载（没有 404 错误）
- [ ] 能看到 "Petpet" 标题
- [ ] 有模板选择器和上传区域

---

### 4️⃣ 访问你的模板

访问：**`https://你的用户名.github.io/petpet-data/?template=beat_up`**

✅ 应该看到：
- [ ] 页面自动选择了 beat_up 模板
- [ ] 可以上传头像图片
- [ ] 点击生成后能看到 GIF 动画
- [ ] 动画有 3 帧效果（不是静态图片）

---

### 5️⃣ 测试功能

1. 上传一张头像图片
2. 等待生成完成
3. 播放 GIF 动画

✅ 应该看到：
- [ ] 头像被正确剪裁成圆形
- [ ] 有两个头像位置（FROM 和 TO）
- [ ] 动画流畅播放（3 帧循环）
- [ ] 可以下载生成的 GIF

---

## 🔧 常见问题

### 问题 1: 页面显示 404

**原因**：GitHub Pages 还未部署完成

**解决**：
1. 等待 2-5 分钟
2. 进入 Settings → Actions
3. 检查是否有正在运行的 workflow
4. 等待 workflow 完成（绿色勾）

---

### 问题 2: 模板未显示

**原因**：文件不在正确的目录

**解决**：
1. 确认文件路径是：`data/beat_up/0.png`、`data/beat_up/1.png`、`data/beat_up/2.png`、`data/beat_up/data.json`
2. 如果文件在根目录，需要移动到 `data/beat_up/` 子目录

---

### 问题 3: 只有静态图片

**原因**：可能只上传了 GIF 文件

**解决**：
1. 确认上传的是 0.png, 1.png, 2.png 三个独立文件
2. data.json 中的 type 应该是 "GIF"

---

### 问题 4: 跨域错误（CORS）

**原因**：浏览器安全策略

**解决**：
1. 这是正常现象，不影响使用
2. 或者在仓库根目录创建 `.nojekyll` 文件

---

## 📊 验证成功标准

如果以上所有 ✅ 都打勾，恭喜你！部署成功！🎉

如果有任何一项未通过，请告诉我具体问题，我会帮你解决。

---

## 🎯 下一步

部署成功后，你可以：

1. **分享给朋友**：发送模板链接
2. **创建更多模板**：重复此流程
3. **集成到网站**：使用 inject.js 脚本

---

## 📝 你的模板信息

- **名称**: beat_up
- **帧数**: 3 帧
- **类型**: GIF 动画
- **特点**: 双圆形头像互动效果

你的专属链接：
```
https://你的用户名.github.io/petpet-data/?template=beat_up
```
