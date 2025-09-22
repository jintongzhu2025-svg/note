@echo off
chcp 65001 > nul
setlocal
echo === Git自动上传工具 ===
echo 仓库：yikeweiliang/note
echo.

REM 确保使用HTTPS远程地址
git remote set-url origin https://github.com/yikeweiliang/note.git

REM 添加所有更改
git add -A
echo ✓ 已暂存所有更改

REM 检查是否有更改需要提交
git diff --cached --quiet
if %errorlevel% == 0 (
    echo ! 没有检测到文件更改
    goto push
)

REM 提交更改
if "%1"=="" (
    git commit -m "自动提交：%date% %time%"
    echo ✓ 已提交更改（使用默认信息）
) else (
    git commit -m "%*"
    echo ✓ 已提交更改：%*
)

:push
REM 尝试推送（最多重试2次）
set retry_count=0

:retry_push
set /a retry_count+=1
echo.
echo [尝试 %retry_count%/2] 正在推送到GitHub...

git push origin master

if %errorlevel% == 0 (
    echo.
    echo ✓ 推送成功！
    echo ✓ 所有操作已完成
    goto success
)

if %retry_count% geq 2 (
    echo.
    echo ✗ 推送失败，已重试2次
    echo.
    echo 可能的原因：
    echo   1. 网络连接问题
    echo   2. GitHub服务暂时不可用
    echo   3. 认证问题（需要输入用户名密码）
    goto error
)

echo ! 推送失败，5秒后重试...
timeout /t 5 /nobreak >nul
goto retry_push

:success
endlocal
exit /b 0

:error
echo.
echo 你可以稍后手动尝试：git push origin master
echo 或者检查网络连接后重试
echo.
pause
exit /b 1