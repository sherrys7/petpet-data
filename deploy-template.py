#!/usr/bin/env python3
"""
Petpet-js 模板部署工具
将 GIF 模板拆分并上传到 GitHub
"""

import os
import sys
import json
import shutil
import subprocess
import tempfile
from pathlib import Path
from PIL import Image

def print_step(message):
    print(f"\n{message}")
    print("=" * 60)

def main():
    template_name = "beat_up"
    template_dir = Path("/workspace/data/moe.d2n.petpet-js") / template_name
    gif_file = template_dir / "background.gif"
    
    print_step("🎨 Petpet-js 模板部署工具")
    
    # 检查 GIF 文件
    if not gif_file.exists():
        print(f"❌ 错误：找不到 GIF 文件 {gif_file}")
        sys.exit(1)
    
    print(f"✅ 找到模板：{template_name}")
    print(f"📁 GIF 文件：{gif_file}")
    
    # 创建临时目录
    work_dir = Path(tempfile.mkdtemp())
    print(f"📂 工作目录：{work_dir}")
    
    # 拆分 GIF
    print_step("🎬 正在拆分 GIF...")
    try:
        gif = Image.open(gif_file)
        frame_count = 0
        
        while True:
            frame = gif.copy()
            frame_path = work_dir / f"{frame_count}.png"
            frame.save(frame_path, "PNG")
            frame_count += 1
            
            try:
                gif.seek(gif.tell() + 1)
            except EOFError:
                break
        
        print(f"✅ 拆分完成，共 {frame_count} 帧")
    except Exception as e:
        print(f"❌ 拆分 GIF 失败：{e}")
        shutil.rmtree(work_dir, ignore_errors=True)
        sys.exit(1)
    
    # 复制 data.json
    data_json = template_dir / "data.json"
    if data_json.exists():
        shutil.copy(data_json, work_dir / "data.json")
        print("✅ 复制 data.json")
    else:
        print("❌ 找不到 data.json")
        shutil.rmtree(work_dir, ignore_errors=True)
        sys.exit(1)
    
    # 列出文件
    print_step("📋 准备上传的文件:")
    for f in work_dir.iterdir():
        size = f.stat().st_size
        print(f"   - {f.name} ({size:,} bytes)")
    
    # 提示用户
    print_step("✨ 部署准备完成!")
    print(f"""
下一步操作:

方法 1 - 使用在线编辑器上传（推荐）:
   1. 打开 https://dituon.github.io/petpet-js/editor/index.html
   2. 登录 GitHub 账户
   3. 上传目录中的文件:
      {work_dir}
   4. 点击上传按钮

方法 2 - 手动上传到 GitHub:
   1. 在 GitHub 创建新仓库: petpet-data
   2. 将以下文件上传到仓库:
      {', '.join([f.name for f in work_dir.iterdir()])}
   3. 上传到 data/{template_name}/ 目录

方法 3 - 使用 GitHub CLI:
   cd {work_dir}
   gh repo create petpet-data --public
   git add .
   git commit -m "feat: add {template_name} template"
   git push -u origin main

临时目录将在会话结束后保留，你可以手动使用这些文件。
""")
    
    # 询问是否继续
    if os.getenv('AUTO_CONFIRM') != '1':
        response = input("是否要继续部署？(y/n): ").strip().lower()
        if response != 'y':
            print("❌ 部署已取消")
            shutil.rmtree(work_dir, ignore_errors=True)
            sys.exit(0)
    
    # 检查 GitHub CLI
    print_step("📝 检查 GitHub 登录状态...")
    try:
        result = subprocess.run(
            ["gh", "auth", "status"],
            capture_output=True,
            text=True
        )
        if result.returncode != 0:
            print("⚠️  未登录 GitHub，请先登录:")
            subprocess.run(["gh", "auth", "login"])
    except FileNotFoundError:
        print("❌ 未安装 GitHub CLI，请安装：https://cli.github.com/")
        print(f"临时文件已保存在：{work_dir}")
        sys.exit(1)
    
    print("✅ GitHub 已登录")
    
    # 获取用户名
    print_step("👤 获取 GitHub 用户名...")
    result = subprocess.run(
        ["gh", "api", "user", "--jq", ".login"],
        capture_output=True,
        text=True
    )
    if result.returncode != 0:
        print("❌ 无法获取用户名")
        sys.exit(1)
    
    username = result.stdout.strip()
    print(f"用户名：{username}")
    
    # 检查/创建仓库
    repo_name = "petpet-data"
    full_name = f"{username}/{repo_name}"
    
    print_step(f"📦 检查仓库 {full_name}...")
    result = subprocess.run(
        ["gh", "repo", "view", full_name],
        capture_output=True
    )
    
    repo_exists = result.returncode == 0
    
    if not repo_exists:
        print(f"🆕 创建新仓库 {repo_name}...")
        os.chdir(work_dir)
        subprocess.run(["git", "init"])
        subprocess.run(["git", "add", "."])
        subprocess.run(["git", "commit", "-m", f"feat: add {template_name} template"])
        subprocess.run(["git", "branch", "-M", "main"])
        
        subprocess.run([
            "gh", "repo", "create", repo_name,
            "--public",
            "--source", ".",
            "--push"
        ])
        
        print(f"✅ 仓库创建成功: https://github.com/{full_name}")
    else:
        print("✅ 仓库已存在")
        print(f"📥 克隆仓库...")
        
        clone_dir = work_dir / "repo"
        subprocess.run([
            "git", "clone",
            f"https://github.com/{full_name}.git",
            str(clone_dir)
        ])
        
        # 复制模板文件
        data_dir = clone_dir / "data" / template_name
        data_dir.mkdir(parents=True, exist_ok=True)
        
        for f in work_dir.iterdir():
            if f.name not in ["repo", "data.json"]:
                shutil.copy(f, data_dir / f.name)
        
        shutil.copy(work_dir / "data.json", data_dir / "data.json")
        
        # 提交并推送
        os.chdir(clone_dir)
        subprocess.run(["git", "add", f"data/{template_name}"])
        subprocess.run(["git", "commit", "-m", f"feat: add {template_name} template"])
        subprocess.run(["git", "push"])
        
        print(f"✅ 模板已上传：https://github.com/{full_name}/tree/main/data/{template_name}")
    
    # 完成
    print_step("🎉 部署完成!")
    print(f"""
使用方式:

在线访问:
  https://{username}.github.io/{repo_name}/?template={template_name}

仓库地址:
  https://github.com/{full_name}

GitHub Pages 设置（如果需要）:
  1. 访问 https://github.com/{full_name}/settings/pages
  2. Source 选择 "Deploy from a branch"
  3. Branch 选择 "main"，文件夹选择 "/ (root)"
  4. 保存
""")
    
    # 清理
    shutil.rmtree(work_dir, ignore_errors=True)
    print("✅ 临时文件已清理")

if __name__ == "__main__":
    main()
