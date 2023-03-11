:: ver 0.03
:: modified 2022/07/05
:: HM

@echo off
echo.

:: Main Menu
:Main
color F
echo Enter number:
echo 1 - Shutdown (+VM)
echo 2 - Restart (+VM)
echo 3 - Shutdown (IP ping)
echo 4 - Shutdown (Time)
echo 5 - Cancel shutdown
echo 0 - Exit
echo.
set /p answer=":> "
echo.
cls
echo.
if %answer%==1 (
    goto Shutdown
) else if %answer%==2 (
    goto Restart
) else if %answer%==3 (
    goto PingHost
) else if %answer%==4 (
    goto Ontime
) else if %answer%==5 (
    goto Cancel
) else if %answer%==0 (
    exit
) else (
    echo "Wrong answer. Try again..."
    timeout /t 2
    cls
    echo.
    goto Main
)

:: Function Stop VM and Shuting down
:Shutdown
color C
set VBoxManageEXE="%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe"
set ListRunningVMS=%VboxManageEXE% list runningvms
for /f tokens^=2^,4^ delims^=^" %%p in ('%ListRunningVMS%') do %VBoxManageEXE% controlvm %%p acpipowerbutton
echo Shuting down...
timeout /t 8
shutdown /s /t 1
cls
echo.
::goto main


:: Function Stoping VM and restarting
:Restart
color E
set VBoxManageEXE="%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe"
set ListRunningVMS=%VboxManageEXE% list runningvms
for /f tokens^=2^,4^ delims^=^" %%p in ('%ListRunningVMS%') do %VBoxManageEXE% controlvm %%p acpipowerbutton
echo Restarting...
timeout /t 8
shutdown /r /t 1
cls
echo.
::goto main

:: PingHost and shutdown
:PingHost
color F
set /p host="Input host ip: "
:loop
color F
cls
echo.
echo Trying to ping %host%
ping %host% -4 -n 2 |>nul findstr "TTL=" && (
    cls
    echo.
    color A
    echo %host% is available! Shuting down...
    timeout /t 3
    cls
    echo.
    goto Shutdown
) || (
    cls
    echo.
    color E
    echo %host% is not available! Retrying in 60 sec:
)
timeout /t 60
goto loop


:: Menu OnTime
:Ontime
color F
echo Enter number:
echo 1 - Shutdown (time)
echo 2 - Restart (time)
echo 3 - Main menu
echo 4 - Exit
echo.
set /p answer=":> "
echo.
cls
echo.

if %answer%==1 (
    goto ShutdownOntime
) else if %answer%==2 (
    goto RestartOntime
) else if %answer%==3 (
    goto Main
) else if %answer%==4 (
    exit
) else (
    echo "Wrong answer. Try again..."
    timeout /t 2
    cls
    echo.
    goto Ontime
)

:: Shutdown On time
:ShutdownOntime
color F
set /p min_off="Shutdown in (minutes): "
echo.
set /A sec_off="%min_off% * 60"
color C
echo Windows will shut down in %min_off% minutes
shutdown -s -f -t %sec_off%
timeout /t 2
cls
echo.
goto main

:: Restart On time
:RestartOntime
color F
set /p min_re="Restart in (minutes): "
echo.
set /A sec_re="%min_re% * 60"
color E
echo Windows will restart in %min_re% minutes
shutdown -r -f -t %sec_re%
timeout /t 5
cls
echo.
goto main

:: Cancel
:Cancel 
color A
echo The scheduled shutdown has been canceled
echo.
shutdown -a
timeout /t 2
cls
echo.
goto main
