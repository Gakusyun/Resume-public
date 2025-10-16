#!/usr/bin/env python3
import os
import sys
import subprocess
from datetime import datetime, timezone, timedelta
from pathlib import Path
import toml


def get_typst_version():
    try:
        result = subprocess.run(['typst', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            return result.stdout.strip()
        else:
            return "typst version unknown"
    except FileNotFoundError:
        return "typst not found"


def get_git_commit_hash():
    """获取当前Git commit hash"""
    try:
        result = subprocess.run(['git', 'rev-parse', 'HEAD'], capture_output=True, text=True)
        if result.returncode == 0:
            return result.stdout.strip()[:8]  # 取前8位
        else:
            return "unknown"
    except FileNotFoundError:
        return "git not found"


def create_footer_content(typst_version, commit_hash):
    # 获取东八区时间
    utc_time = datetime.now(timezone.utc)
    beijing_time = utc_time + timedelta(hours=8)
    current_time = beijing_time.strftime("%Y-%m-%d %H:%M:%S")
    
    footer_content = f'''#place(
  right + bottom,
  float: true,
)[
  #set text(
    font: "Maple Mono",
    size: 8pt,
  )
  Compiled by {typst_version} \\
  compile date(UTC+8): {current_time} \\
  git commit hash: {commit_hash}
]'''
    
    return footer_content


def compile_resume(input_file):
    """编译简历文件"""
    input_path = Path(input_file)
    
    if not input_path.exists():
        print(f"错误: 文件 '{input_file}' 不存在")
        return False
    
    if not input_path.suffix == '.typ':
        print(f"错误: 文件 '{input_file}' 不是有效的Typst文件")
        return False
    
    # 获取版本信息
    typst_version = get_typst_version()
    commit_hash = get_git_commit_hash()
    
    # 创建临时文件在当前目录，确保相对路径正常工作
    # 获取东八区时间戳
    utc_time = datetime.now(timezone.utc)
    beijing_time = utc_time + timedelta(hours=8)
    temp_filename = f"temp_{input_path.stem}_{int(beijing_time.timestamp())}.typ"
    temp_path = input_path.parent / temp_filename
    
    # 读取原文件内容
    with open(input_path, 'r', encoding='utf-8') as f:
        original_content = f.read()
    
    # 添加页脚内容
    footer_content = create_footer_content(typst_version, commit_hash)
    modified_content = original_content + '\n\n' + footer_content
    
    # 写入临时文件
    with open(temp_path, 'w', encoding='utf-8') as f:
        f.write(modified_content)
    
    try:
        # 编译临时文件
        output_file = input_path.stem + '.pdf'
        result = subprocess.run(['typst', 'compile', temp_path, output_file], 
                              capture_output=True, text=True)
        
        if result.returncode == 0:
            print(f"✅ 编译成功: {output_file}")
            print(f"   Typst版本: {typst_version}")
            print(f"   Git commit: {commit_hash}")
            # 获取东八区时间
            utc_time = datetime.now(timezone.utc)
            beijing_time = utc_time + timedelta(hours=8)
            print(f"   编译时间: {beijing_time.strftime('%Y-%m-%d %H:%M:%S')}")
            return True
        else:
            print(f"❌ 编译失败: {result.stderr}")
            return False
    
    finally:
        # 删除临时文件
        try:
            os.unlink(temp_path)
        except OSError:
            pass


def main():
    """主函数"""
    # 读取config.toml文件
    config = toml.load("config.toml")
    resume_file = config['resume']['resume_file']
    success = compile_resume(resume_file)
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()