@echo off

ping HOST -4 -n 3 |>nul findstr "TTL=" && (
  ipconfig|find/i "t_1" || (SCHTASKS /End /TN "t_2" & C:\Windows\System32\rasdial.exe "t_2" /disconnect & SCHTASKS /Run /TN "t_1")
) || (
  ipconfig|find/i "t_2" || (SCHTASKS /End /TN "t_1" & C:\Windows\System32\rasdial.exe "t_1" /disconnect & SCHTASKS /Run /TN "t_2")
)
