# 🔐 Complete CLI Security & Productivity Stack

**GPG-encrypted passwords. Terminal-based everything. Battle-tested for years.**

## The Complete System
- **OS:** Arch Linux (rolling release)
- **Passwords:** pass (GPG + git sync)
- **Mail:** mutt/neomutt + offlineimap (pass integration)
- **Calendar:** vdirsyncer + khal (pass-managed auth)  
- **Contacts:** vdirsyncer + khard (pass-secured)
- **Tasks:** todoman
- **Browser:** qutebrowser
- **Editor:** nvim (Lua config)
- **WM:** sway (Wayland tiling)

## What You Get
- **Zero GUI dependencies** - runs over SSH  
- **Complete offline capability** - airplane mode ready  
- **Sync everywhere** - phone, laptop, server  
- **Lightning fast** - no bloated clients  
- **Highly scriptable** - automate everything  

## Target Audience
- Developers who live in terminal
- Privacy-conscious users  
- People tired of Electron apps
- Anyone who values speed over shininess

## Security Model
- **All passwords GPG-encrypted** (pass store)  
- **No plaintext credentials** anywhere  

## Integration Examples
```bash
# offlineimap pulls passwords from pass
passwordeval = pass show email/work/password

# vdirsyncer uses pass for credentials  
password.fetch = ["command", "pass", "show", "caldav/nextcloud"]
```

## Not Included
- Fancy animations
- RGB everywhere  
- Experimental features
- Configs that break next week

---
*"Why click when you can type?"*
