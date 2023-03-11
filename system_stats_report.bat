@echo off
REM ver 0.2
REM modified 2022/06/19

Title Batch Script to get CPU %% and MEM %% Usage
Color 0A

REM cpu use threshold
set cpu_threshold=85
REM mem idle threshold
set mem_threshold=256
REM disk use threshold
set disk_threshold=2048

set "CpuUsage=0"
set "Processors=0"

%SystemRoot%\System32\wbem\wmic.exe CPU get loadpercentage >"%TEMP%\cpu_usage.tmp"
for /F "skip=1" %%P in ('type "%TEMP%\cpu_usage.tmp"') do (
    set /A CpuUsage+=%%P
    set /A Processors+=1
)

del "%TEMP%\cpu_usage.tmp"

set /A CpuUsage/=Processors

for /F "skip=1" %%M in ('%SystemRoot%\System32\wbem\wmic.exe OS get FreePhysicalMemory') do set "AvailableMemory=%%M" & goto :continue

:continue

set /A AvailableMemory/=1024

if %CpuUsage% geq %cpu_threshold% (
    call :sender "CPU warning !!! Utilization: %CpuUsage% pct."
)

if %AvailableMemory% leq %mem_threshold% (
    call :sender "RAM warning !!! Utilization: %AvailableMemory% MB"
)

:sender
FOR /F "tokens=4 delims= " %%i in ('route print ^| find " 0.0.0.0"') do set localIp=%%i
SET TOKEN_BOT=XXXX
SET ID_CHAT=-AAAA
SET URL=https://api.telegram.org/bot%TOKEN_BOT%/sendMessage
curl -v -X POST --silent --output /dev/null %URL% -d chat_id=%ID_CHAT% -d text="%localIp%: %~1"

Pause & Exit
