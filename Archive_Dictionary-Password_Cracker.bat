::------------------------------------------------------------------------------
:: NAME
::     Archive_Dictionary-Password_Cracker.bat - Archive Dictionary-Password Cracker
::
:: DESCRIPTION
::     Extract an given archive using 7za extracting utility,
::     using dictionary brute-force attack.
::
:: AUTHOR
::     IB_U_Z_Z_A_R_Dl
::------------------------------------------------------------------------------
@echo off
cls
>nul chcp 65001

setlocal DisableDelayedExpansion
pushd "%~dp0"
setlocal EnableDelayedExpansion

set TITLE=Archive Dictionary-Password Cracker
title !TITLE!
set "DICTIONARY_COMBOLIST=lib\the_batch_dictionary-password_list.txt"
:: set "LOOKUP_BLACKLISTED_PASSWORDS=|XPath|"

:PROMPT_USER_ARCHIVE_PATH
cls
echo:
if defined user_archive_path (
    set user_archive_path=
)
set /p "user_archive_path=Enter the archive you want to crack: "
call :CHECK_PATH_EXIST user_archive_path || (
    goto :PROMPT_USER_ARCHIVE_PATH
)
for %%A in ("!user_archive_path!") do (
    if /i not "%%~xA"==".zip" if /i not "%%~xA"==".7z" if /i not "%%~xA"==".rar" (
        goto :PROMPT_USER_ARCHIVE_PATH
    )
    set "user_archive_fullname=%%~nxA"
    set "user_archive_name=%%~nA"
)
if defined reveal_password (
    set reveal_password=
)
echo:
title Loading password variable array - !TITLE!
echo Loading password variable array (loading memory) . . .
echo:
set password[#]=0
for /f "usebackq" %%A in ("!DICTIONARY_COMBOLIST!") do (
    set /a password[#]+=1
    set "password[!password[#]!]=%%A"
)
for /f "delims=" %%A in ('2^>nul dir "!user_archive_name!.*" /a:-d /b /o:d') do (
    if not "%%A"=="!user_archive_fullname!" (
        del "%%A"
    )
)
for /l %%A in (1,1,!password[#]!) do (
    2>nul title Trying password: "!password[%%A]!" - !TITLE!
    echo Trying password: "!password[%%A]!"
    >nul 2>&1 lib\7za\x64\7za.exe x "!user_archive_path!" -p"!password[%%A]!" && (
        set "reveal_password=!password[%%A]!"
        goto :FINISHED
    )
    for /f "delims=" %%B in ('2^>nul dir "!user_archive_name!.*" /a:-d /b /o:d') do (
        if not "%%B"=="!user_archive_fullname!" (
            del "%%B"
        )
    )
)
:FINISHED
echo:
if defined reveal_password (
    title Archive successfully extracted - !TITLE!
    echo successfully extracted: "!user_archive_path!"
    echo Password: "!reveal_password!"
) else (
    title Archive not extracted - !TITLE!
    echo Sorry, couldn't extract the archive ...
)

echo:
<nul set /p=Press {ANY KEY} to exit ...
>nul pause

popd
exit /b 0

:CHECK_PATH_EXIST
if not defined %1 exit /b 1
set "%1=!%1:"=!"
if not defined %1 exit /b 1
set "%1=!%1:/=\!"
:CHECK_PATH_EXIST_STRIP_WHITE_SPACES
if "!%1:~0,1!"==" " (
set "%1=!%1:~1!"
goto :CHECK_PATH_EXIST_STRIP_WHITE_SPACES
)
:_CHECK_PATH_STRIP_WHITE_SPACES
if "!%1:~-1!"==" " (
set "%1=!%1:~0,-1!"
goto :_CHECK_PATH_STRIP_WHITE_SPACES
)
:CHECK_PATH_EXIST_STRIP_SLASHES
if "!%1:~-2!"=="\\" (
set "%1=!%1:~0,-1!"
goto :CHECK_PATH_EXIST_STRIP_SLASHES
)
if exist "!%1!" exit /b 0
exit /b 1