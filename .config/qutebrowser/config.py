# ~/.config/qutebrowser/config.py

config.load_autoconfig()

# Catppuccin Theme
import catppuccin

# Dark Mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.page = "smart"

# choose Catppuccin variant 
catppuccin.setup(c, 'mocha')      # Dunkel
# catppuccin.setup(c, 'macchiato') # Mitteldunkel  
# catppuccin.setup(c, 'frappe')    # Mittel
# catppuccin.setup(c, 'latte')     # Hell

# Settings
c.fonts.default_size = '12pt'
#c.fonts.tabs.selected = '12pt monospace'
#c.fonts.tabs.unselected = '12pt monospace'
#c.tabs.padding = {'top': 5, 'bottom': 5, 'left': 5, 'right': 5}

config.bind('<Ctrl+Shift+p>', 'spawn --userscript qute-bitwarden')
c.content.local_content_can_access_file_urls = True
c.content.local_content_can_access_remote_urls = True
