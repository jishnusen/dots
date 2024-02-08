return {
  "nyoom-engineering/oxocarbon.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    vim.opt.background = "dark" -- set this to dark or light
    vim.cmd.colorscheme "oxocarbon"
  end
}
