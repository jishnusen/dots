return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.5',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    vim.keymap.set("n", "<Leader>/", require("telescope.builtin").find_files, { silent = true })
  end
}
