-- ~/.config/nvim/init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

vim.opt.laststatus = 2
vim.opt.number = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

require("lazy").setup({
  {"catppuccin/nvim", name = "catppuccin", config = function() 
    require("catppuccin").setup({
      transparent_background = true,
    })
    vim.cmd.colorscheme("catppuccin-mocha") 
  end},
  {"nvim-lualine/lualine.nvim", config = function() require("lualine").setup({options = {theme = "catppuccin"}}) end},
  {"windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup({}) end},
  {"lervag/vimtex"},
  {"davidhalter/jedi-vim"},
  {"rhysd/vim-notes-cli"},
})
