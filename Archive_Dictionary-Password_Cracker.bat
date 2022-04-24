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
for /f %%A in ('copy /z "%~nx0" nul') do (
    set "\R=%%A"
)
setlocal EnableDelayedExpansion

set TITLE=Archive Dictionary-Password Cracker
title !TITLE!
if defined ProgramFiles(x86) (
    set ARCH=64
) else (
    set ARCH=86
)
set "DICTIONARY_COMBOLIST=lib\the_batch_dictionary-password_list.txt"
if defined user_archive_path (
    set user_archive_path=
)
if not "%~1"=="" (
    set "user_archive_path=%~1"
    goto :LABEL_CHECK_PATH_EXIST
)
:PROMPT_USER_ARCHIVE_PATH
cls
echo:
if defined user_archive_path (
    set user_archive_path=
)
echo Enter the archive you want to crack (*.zip, *.7z)
set /p "user_archive_path=Archive: "
:LABEL_CHECK_PATH_EXIST
call :CHECK_PATH_EXIST user_archive_path || (
    goto :PROMPT_USER_ARCHIVE_PATH
)
for %%A in ("!user_archive_path!") do (
    if /i not "%%~xA"==".zip" (
        if /i not "%%~xA"==".7z" (
            goto :PROMPT_USER_ARCHIVE_PATH
        )
    )
    set "user_archive_foldernamepath=%%~dpnA\"
    set "user_archive_fullname=%%~nxA"
    set "user_archive_name=%%~nA"
)
for %%A in (password_reveal password_empty) do (
    if defined %%A (
        set %%A=
    )
)
lib\7za\x!ARCH!\7za.exe x -aoa -bd -bso0 -bse0 -o"!user_archive_foldernamepath!" -y "!user_archive_path!" -p"" && (
    set password_empty=1
    goto :FINISHED
)
if exist "!user_archive_foldernamepath!" (
    rd /s /q "!user_archive_foldernamepath!"
)
echo:
echo Loading password(s) counter variable (loading memory) . . .
echo:
set password_counter=0
for /f "usebackq" %%A in ("!DICTIONARY_COMBOLIST!") do (
    set /a password_counter+=1
    title Progress: [0%%]  ^|  [0/!password_counter!] - !TITLE!
)
if defined progress_bar (
    set progress_bar=
)
if exist "!user_archive_foldernamepath!" (
    rd /s /q "!user_archive_foldernamepath!"
)
for /f "tokens=1-4delims=:.," %%A in ("!time: =0!") do set /a "t1=(((1%%A*60)+1%%B)*60+1%%C)*100+1%%D-36610100"
for /f "usebackq" %%A in ("!DICTIONARY_COMBOLIST!") do (
    for /f "tokens=1-4delims=:.," %%B in ("!time: =0!") do set /a "t2=(((1%%B*60)+1%%C)*60+1%%D)*100+1%%E-36610100, tDiff=t2-t1, tDiff+=((~(tDiff&(1<<31))>>31)+1)*8640000, seconds=tDiff/100, hours=seconds/3600, minutes=seconds/60%%60, seconds=seconds%%60"
    if !hours! gtr 0 (
        set "time_elapsed=!hours!h !minutes!m !seconds!s"
    ) else if !minutes! gtr 0 (
        set "time_elapsed=!minutes!m !seconds!s"
    ) else (
        set "time_elapsed=!seconds!s"
    )
    set /a counter+=1, percentage=counter*100/password_counter, pb_progress=percentage/4
    set progress_bar=
    for /l %%B in (1,1,!pb_progress!) do (
        set progress_bar=!progress_bar!█
    )
    set "progress_bar=!progress_bar!░░░░░░░░░░░░░░░░░░░░░░░░░"
    set "pad=%%A........"
    title Progress: [!percentage!%%]  ^|  [!counter!/!password_counter!] - !TITLE!
    <nul set /p="Trying password: "!pad:~0,8!..." │!progress_bar:~0,25!│ (!percentage!%%) | Time-Elapsed: !time_elapsed! !\R!"
    lib\7za\x!ARCH!\7za.exe x -aoa -bd -bso0 -bse0 -o"!user_archive_foldernamepath!" -y "!user_archive_path!" -p"%%A" && (
        set "password_reveal=%%A"
        goto :FINISHED
    )
    if exist "!user_archive_foldernamepath!" (
        rd /s /q "!user_archive_foldernamepath!"
    )
)
:FINISHED
if defined progress_bar (
    echo:
)
echo:
if defined password_empty (
    title Archive successfully extracted - !TITLE!
    echo Successfully extracted: "!user_archive_path!"
    echo The archive is not protected from a password.
) else if defined password_reveal (
    title Archive successfully extracted - !TITLE!
    echo Successfully extracted: "!user_archive_path!"
    echo Password: "!password_reveal!" ^(!counter!/!password_counter!^)
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