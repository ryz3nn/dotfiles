return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-day")
      -- vim.cmd.colorscheme("vim")
    end,
  },
}
