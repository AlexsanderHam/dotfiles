-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Tab / indent (match VS Code + Biome: 2 spaces)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Scroll context
vim.opt.scrolloff = 8

-- System clipboard (Cmd+C/V works)
vim.opt.clipboard = "unnamedplus"

-- Mouse support (click to position cursor)
vim.opt.mouse = "a"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
