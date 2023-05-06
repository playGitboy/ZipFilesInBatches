@echo off
setlocal EnableDelayedExpansion
REM 设置分批压缩文件个数 
set batch_size=15

REM 兼容判断拖放过来的是目录还是文件
if "%~dp1"=="" (
    echo 请将待压缩文件所在的目录拖放到这里，不要直接拖放文件过来！！
    pause>nul
)

set "item_type="
set "item_path=%~1"
REM 这里BUG注意：以下两行dir不能换位置，否则目录中带有"."会被误判为文件
dir /A:-D /B "!item_path!" >nul 2>nul && set "item_type=file"
dir /A:D /B "!item_path!" >nul 2>nul && set "item_type=dir"

if "%item_type%"=="file" (
    echo 请将待压缩文件所在的目录拖放到这里，不要直接拖放文件过来！！
    pause>nul
) 

REM 递归处理子目录
for /r "%~1" %%A in (.) do (
    if /i not "%%~nxA"=="Compressed" (
        set "source_path=%%~fA"
        set "dest_dir=!source_path!\Compressed"
        if not exist "!dest_dir!" (
            md "!dest_dir!"
        )
        set count=0
        set batch_num=1
        for %%F in ("!source_path!\*") do (
            set /a count+=1
            if !count! == 1 (
                set batch_name=batch_!batch_num!.zip
                ".\7zip\7z" a -tzip "!dest_dir!\!batch_name!" "%%F"
            ) else (
                ".\7zip\7z" a -tzip "!dest_dir!\!batch_name!" "%%F"
            )
            if !count! == %batch_size% (
                set /a count=0
                set /a batch_num+=1
            )
        )
    )
)

REM 处理根目录
set "root_path=%~1"
set "root_dir=%~nx1"
if "%root_dir%"=="" set "root_dir=%~dpnx1"
if "%root_dir:~-1%"=="\" set "root_dir=%root_dir:~0,-1%"
set "dest_dir=%root_dir%\Compressed"
if not exist "!dest_dir!" (
    md "!dest_dir!"
)
set count=0
set batch_num=1
for %%F in ("%root_path%\*") do (
    if /i not "%%~nxF"=="Compressed" (
        set /a count+=1
        if !count! == 1 (
            set batch_name=batch_!batch_num!.zip
            ".\7zip\7z" a -tzip "!dest_dir!\!batch_name!" "%%F"
        ) else (
            ".\7zip\7z" a -tzip "!dest_dir!\!batch_name!" "%%F"
        )
        if !count! == %batch_size% (
            set /a count=0
            set /a batch_num+=1
        )
    )
)
pause