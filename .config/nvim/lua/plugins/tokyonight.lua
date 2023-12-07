return {
  "folke/tokyonight.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    styles = {
--    comments = { italic = false },
--    keywords = { italic = false },
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts);
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
