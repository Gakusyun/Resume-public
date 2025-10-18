
#!/usr/bin/env python3
import os
import sys
import subprocess
from datetime import datetime, timezone, timedelta
from pathlib import Path
import toml


def get_typst_version():
    result = subprocess.run(['typst', '--version'], capture_output=True, text=True)
    return result.stdout.strip()


def get_git_commit_hash():
    """获取当前Git commit hash"""
    result = subprocess.run(['git', 'rev-parse', 'HEAD'], capture_output=True, text=True)
    return result.stdout.strip()[:8]  # 取前8位
        
def get_system_info():
    result = subprocess.run(['uname','-a'],capture_output=True, text=True)
    return result.stdout.strip()

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

  Compile time(UTC+8): {current_time} \\
  Compiled by {typst_version} \\
  Git commit hash: {commit_hash} 
]'''
    
    return footer_content


def compile_resume(input_file):
    """编译简历文件"""
    input_path = Path(input_file)
    
    # 获取版本信息
    typst_version = get_typst_version()
    commit_hash = get_git_commit_hash()
    # system_info = get_system_info()
    
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
    output_file = input_path.stem + '.pdf'
    result = subprocess.run(['typst', 'compile', temp_path, output_file], 
                              capture_output=True, text=True)

def main():
    """主函数"""
    # 读取config.toml文件
    config = toml.load("config.toml")
    resume_file = config['resume']['resume_file']
    compile_resume(resume_file)

if __name__ == "__main__":
    main()