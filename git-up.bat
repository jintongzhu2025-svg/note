@echo off
chcp 65001 > nul
setlocal
echo === Git自动上传工具 ===
echo 仓库：yikeweiliang/note
echo.

REM 确保使用HTTPS远程地址
git remote set-url origin https://github.com/yikeweiliang/note.git

REM 添加所有更改
git add .

git commit -m "自动提交：%date% %time%"

git push temp_branch
