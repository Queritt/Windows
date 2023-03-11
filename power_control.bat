@echo off
rem Power control
rem version 0.04
rem modified 2022/07/10
SET TOKEN_BOT=XXXX:YYYY_ZZZZZZZZ
SET ID_CHAT=-XXXXXX
SET URL=https://api.telegram.org/bot%TOKEN_BOT%/sendMessage
rem name of TLGRM
set name=WM
rem Battery level after which task and VMs are stopped.
set saveThreshold=70
rem Access to AC
set powerStatus=false
rem Save battery by ending tasks and VMs
set saveMode=false
rem Battery fully charged
set fullCharge=false

:start
timeout /t 60
rem Battery Status: 1 - not access to AC, 2 - access to AC
for /f "usebackq skip=1 tokens=1" %%i in (`wmic Path Win32_Battery Get BatteryStatus ^| findstr /r /v "^$"`) do (
    set status=%%i
) 
rem Battery charge level
for /f "usebackq skip=1 tokens=1" %%i in (`wmic Path Win32_Battery Get EstimatedChargeRemaining ^| findstr /r /v "^$"`) do (
    set charge=%%i
)

if %status% == 2 (
    if %powerStatus%==false (
        set powerStatus=true
        set saveMode=false
        echo %date% %time% %ComputerName%: power restored, battery available: %charge%%%. >> %UserProfile%\power_control.log
        curl -v -X POST --silent --output /dev/null %URL% -d chat_id=%ID_CHAT% -d text="%name% power restored, battery available: %charge%%%."
    ) else (
        echo %date% %time% %ComputerName%: has access to AC, battery available: %charge%%%. >> %UserProfile%\power_control.log
    )
    if %fullCharge%==false (
        if %charge%==100 (
            set fullCharge=true
            echo %date% %time% %ComputerName%: battery fully charged. >> %UserProfile%\power_control.log
            curl -v -X POST --silent --output /dev/null %URL% -d chat_id=%ID_CHAT% -d text="%name% battery fully charged."
        )
    )
    goto start
)

if %status% == 1 (
    if %powerStatus%==true (
        set powerStatus=false
        set fullCharge=false
        echo %date% %time% %ComputerName%: power lost, battery available: %charge%%%. >> %UserProfile%\power_control.log
        curl -v -X POST --silent --output /dev/null %URL% -d chat_id=%ID_CHAT% -d text="Warning! %name% power lost, battery available: %charge%%%."
    )
    if %saveMode%==false (
        if %charge% leq %saveThreshold% (
            rem WM
            call "C:\Users\User\PWROff.bat"
            rem TM2
            psexec \\DESKTOP-NRCQZR8 -u User -p PASSWORD -i -d -n 10 cmd /c C:\Users\User\PWROff.bat
            psexec \\DESKTOP-NRCQZR8 -u Test -p PASSWORD -i -d -n 10 cmd /c C:\Users\Test\PWROff.bat
            rem TM5
            psexec \\DESKTOP-JNJQ8PI -u User -p PASSWORD -i -d -n 10 cmd /c C:\Users\User\PWROff.bat
            rem TM3
            psexec \\DESKTOP-JN3SMCE -u User -p PASSWORD -i -d -n 10 cmd /c C:\Users\User\PWROff.bat
            rem TM4
            psexec \\DESKTOP-ON8SRCV -u User -p PASSWORD -i -d -n 10 cmd /c C:\Users\User\PWROff.bat
            set saveMode=true
            echo %date% %time% %ComputerName%: battery available: %charge%%%, save mode enabled. >> %UserProfile%\power_control.log
            curl -v -X POST --silent --output /dev/null %URL% -d chat_id=%ID_CHAT% -d text="Warning! %name% battery available: %charge%%%, save mode enabled."
        )
    )
    goto start
)
goto start
