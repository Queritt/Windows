@echo off
rem PWROff
rem ver 0.1
rem modifeid 2022/07/10

rem Workers:

for /F "tokens=1,2* delims= " %%A in ('tasklist /v /fi "IMAGENAME eq cmd.exe"') do (echo:%%C|findstr "WRK" >Nul && set "pid=%%B") 
taskkill /PID %pid% /F /T
for /F "tokens=1,2* delims= " %%A in ('tasklist /v /fi "IMAGENAME eq cmd.exe"') do (echo:%%C|findstr "WRK" >Nul && set "pid=%%B") 
taskkill /PID %pid% /F /T
for /F "tokens=1,2* delims= " %%A in ('tasklist /v /fi "IMAGENAME eq cmd.exe"') do (echo:%%C|findstr "WRK" >Nul && set "pid=%%B") 
taskkill /PID %pid% /F /T

rem VMs:
set VBoxManageEXE="%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe"
set ListRunningVMS=%VboxManageEXE% list runningvms
for /f tokens^=2^,4^ delims^=^" %%p in ('%ListRunningVMS%') do %VBoxManageEXE% controlvm %%p acpipowerbutton
