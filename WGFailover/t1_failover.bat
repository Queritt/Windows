@echo off
rem WireGuard
rem 0.1
rem 2022/10/12

ping SERVER_IP -4 -n 5 |>nul findstr "TTL=" && (
  ipconfig|find/i "t_1" || ("C:\Program Files\WireGuard\wireguard.exe" /uninstalltunnelservice "t_2" & "C:\Program Files\WireGuard\wireguard.exe" /installtunnelservice "C:\Program Files\WireGuard\Data\Configurations\t_1.conf.dpapi")
) || (
  ipconfig|find/i "t_2" || ("C:\Program Files\WireGuard\wireguard.exe" /uninstalltunnelservice "t_1" & "C:\Program Files\WireGuard\wireguard.exe" /installtunnelservice "C:\Program Files\WireGuard\Data\Configurations\t_2.conf.dpapi")
)
