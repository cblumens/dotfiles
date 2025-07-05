#!/bin/bash

# battery
battery() {
    if [[ -f /sys/class/power_supply/BAT0/capacity ]]; then
        local bat_cap=$(cat /sys/class/power_supply/BAT0/capacity)
        local bat_status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
        
        if [[ $bat_status == "Charging" ]]; then
            echo "BAT ${bat_cap} CHG"
        else
            echo "BAT ${bat_cap}"
        fi
    else
        echo "AC"
    fi
}

# wifi
wifi() {
    local wifi_info
    wifi_info=$(nmcli -t -f active,signal dev wifi | grep '^yes' | head -1)
    if [[ -n "$wifi_info" ]]; then
        local signal=$(echo "$wifi_info" | cut -d: -f2)
        echo "WIFI ${signal}"
    else
        echo "WIFI OFF"
    fi
}

# vpn
vpn() {
    local vpn_active=$(nmcli -t -f NAME,TYPE connection show --active | grep vpn | head -1)
    if [[ -n "$vpn_active" ]]; then
        echo "VPN"
    fi
}

# volume
volume() {
    local vol=$(pamixer --get-volume 2>/dev/null || echo "0")
    local mute_status=$(pamixer --get-mute 2>/dev/null)
    
    if [[ "$mute_status" == "true" ]]; then
        echo "VOL MUTE"
    elif [[ $vol -eq 0 ]]; then
        echo "VOL 0"
    else
        echo "VOL ${vol}"
    fi
}

# cpu load
cpu() {
    local load=$(cut -d' ' -f1 /proc/loadavg)
    echo "LOAD $load"
}

# uptime
uptime() {
    local uptime_seconds=$(awk '{print int($1)}' /proc/uptime)
    local days=$((uptime_seconds / 86400))
    local hours=$(((uptime_seconds % 86400) / 3600))
    local minutes=$(((uptime_seconds % 3600) / 60))
    
    if [[ $days -gt 0 ]]; then
        echo "UP ${days}d ${hours}h"
    elif [[ $hours -gt 0 ]]; then
        echo "UP ${hours}h ${minutes}m"
    else
        echo "UP ${minutes}m"
    fi
}

# minimal output - only show vpn when active
vpn_status=$(vpn)
if [[ -n "$vpn_status" ]]; then
    echo "$(uptime)  $(cpu)  $(volume)  $(wifi)  $(vpn)  $(battery)  $(date +'%Y-%m-%d %H:%M')"
else
    echo "$(uptime)  $(cpu)  $(volume)  $(wifi)  $(battery)  $(date +'%Y-%m-%d %H:%M')"
fi
