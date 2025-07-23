# ~/.config/qutebrowser/config.py

config.load_autoconfig()

# Catppuccin Theme
import catppuccin

# Dark Mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.page = "smart"

# choose Catppuccin variant 
catppuccin.setup(c, 'mocha')      # Dunkel

# Settings
c.fonts.default_size = '11pt'
c.fonts.default_family = 'JetBrains Mono NF'

c.content.local_content_can_access_file_urls = True
c.content.local_content_can_access_remote_urls = True
