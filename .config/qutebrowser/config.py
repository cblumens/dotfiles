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
c.fonts.default_size = '12pt'

c.content.local_content_can_access_file_urls = True
c.content.local_content_can_access_remote_urls = True

c.fileselect.handler = 'external'
c.fileselect.single_file.command = ['zenity', '--file-selection']
c.fileselect.multiple_files.command = ['zenity', '--file-selection', '--multiple']
c.fileselect.folder.command = ['zenity', '--file-selection', '--directory']
