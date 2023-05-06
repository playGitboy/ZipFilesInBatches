@echo off
setlocal EnableDelayedExpansion
REM ���÷���ѹ���ļ����� 
set batch_size=15

REM �����ж��ϷŹ�������Ŀ¼�����ļ�
if "%~dp1"=="" (
    echo �뽫��ѹ���ļ����ڵ�Ŀ¼�Ϸŵ������Ҫֱ���Ϸ��ļ���������
    pause>nul
)

set "item_type="
set "item_path=%~1"
REM ����BUGע�⣺��������dir���ܻ�λ�ã�����Ŀ¼�д���"."�ᱻ����Ϊ�ļ�
dir /A:-D /B "!item_path!" >nul 2>nul && set "item_type=file"
dir /A:D /B "!item_path!" >nul 2>nul && set "item_type=dir"

if "%item_type%"=="file" (
    echo �뽫��ѹ���ļ����ڵ�Ŀ¼�Ϸŵ������Ҫֱ���Ϸ��ļ���������
    pause>nul
) 

REM �ݹ鴦����Ŀ¼
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

REM �����Ŀ¼
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