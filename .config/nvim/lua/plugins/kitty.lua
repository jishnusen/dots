return {
  'jishnusen/kitty-runner.nvim',
  dev = true,
  config = function()
    require("kitty-runner").setup({
      type = "window"
    })
    vim.keymap.set("n", "<leader>ti",
      function()
        require("kitty-runner.kitty-runner").run_command("ipython")
      end
    )
    vim.api.nvim_create_autocmd({ "ExitPre" }, {
      pattern = { "*" },
      command = [[KittyKillRunner]],
    })
  end
}
