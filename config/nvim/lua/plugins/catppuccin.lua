-- Catppuccin Mocha theme (matches Ghostty + VS Code + Starship + bat)
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        mason = true,
        neo_tree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
        mini = { enabled = true },
      },
    },
  },

  -- Tell LazyVim to use catppuccin as the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
