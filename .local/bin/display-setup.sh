#!/bin/bash

# Sway Multi-Monitor Setup Script
# Automatic configuration based on lid status and available monitors

# Get outputs as JSON
outputs_json=$(swaymsg -t get_outputs)

# Find all available outputs (including inactive ones)
all_outputs=$(echo "$outputs_json" | jq -c '.[]')

# Find external monitors (everything except eDP-1)
external_outputs=$(echo "$all_outputs" | jq -c 'select(.name != "eDP-1")')

# Laptop display info
laptop_output=$(echo "$all_outputs" | jq -c 'select(.name == "eDP-1")')

# Check lid status (works on most laptops)
lid_closed=false
if [[ -f /proc/acpi/button/lid/LID/state ]]; then
    lid_state=$(cat /proc/acpi/button/lid/LID/state | awk '{print $2}')
    [[ "$lid_state" == "closed" ]] && lid_closed=true
elif [[ -f /proc/acpi/button/lid/LID0/state ]]; then
    lid_state=$(cat /proc/acpi/button/lid/LID0/state | awk '{print $2}')
    [[ "$lid_state" == "closed" ]] && lid_closed=true
fi

echo "Lid Status: $([ "$lid_closed" = true ] && echo "CLOSED" || echo "OPEN")"

# Count external monitors
external_count=$(echo "$external_outputs" | wc -l)
echo "External monitors found: $external_count"

# Function: Activate monitor with maximum resolution
activate_output() {
    local output_info="$1"
    local name=$(echo "$output_info" | jq -r '.name')
    
    # Check if monitor is available
    if [[ $(echo "$output_info" | jq -r '.make') == "null" ]]; then
        echo "Monitor $name not available - skipping"
        return
    fi
    
    # Find maximum resolution
    local mode=$(echo "$output_info" | jq -r '.modes | max_by(.width * .height)')
    local width=$(echo "$mode" | jq -r '.width')
    local height=$(echo "$mode" | jq -r '.height')
    local refresh=$(echo "$mode" | jq -r '.refresh')
    
    # Activate monitor
    echo "Activating $name with ${width}x${height}@${refresh}Hz"
    swaymsg output "$name" enable
    swaymsg output "$name" mode "${width}x${height}@${refresh}Hz"
    
    # Set appropriate scaling based on monitor type
    if [[ $name == "eDP-1" ]]; then
        # Laptop display: normal scaling
        echo "Setting 1x scaling for laptop display $name"
        swaymsg output "$name" scale 1
    else
        # External monitor: 25% larger
        echo "Setting 1.25x scaling for external monitor $name"
        swaymsg output "$name" scale 1.5
    fi
}

# Function: Deactivate monitor
deactivate_output() {
    local name="$1"
    echo "Deactivating $name"
    swaymsg output "$name" disable
}

# MAIN LOGIC
if [[ $external_count -gt 0 ]]; then
    echo "External monitors present"
    
    # Activate all external monitors
    echo "$external_outputs" | while read -r output; do
        activate_output "$output"
    done
    
    if [[ "$lid_closed" == true ]]; then
        echo "Lid closed - external monitors only"
        deactivate_output "eDP-1"
    else
        echo "Lid open - laptop + external monitors"
        if [[ -n "$laptop_output" ]]; then
            activate_output "$laptop_output"
        fi
    fi
    
else
    echo "No external monitors - laptop display only"
    
    # Deactivate all external outputs (if still active)
    echo "$all_outputs" | jq -r 'select(.name != "eDP-1") | .name' | while read -r name; do
        [[ -n "$name" ]] && deactivate_output "$name"
    done
    
    # Activate laptop display
    if [[ -n "$laptop_output" ]]; then
        activate_output "$laptop_output"
    fi
fi

echo "Monitor setup completed"

# Optional: Reset wallpaper (if you use one)
# swaymsg output "*" bg ~/.config/sway/wallpaper.jpg fill

# Optional: Adjust workspace layout
if [[ $external_count -gt 0 && "$lid_closed" == false ]]; then
    # With multiple monitors: distribute workspaces
    echo "Distributing workspaces across monitors..."
    
    # Find first external display
    first_external=$(echo "$external_outputs" | head -1 | jq -r '.name')
    
    # Workspaces 1-5 on external monitor, 6-10 on laptop
    for i in {1..5}; do
        swaymsg workspace "$i" output "$first_external"
    done
    
    for i in {6..10}; do
        swaymsg workspace "$i" output "eDP-1"
    done
fi
