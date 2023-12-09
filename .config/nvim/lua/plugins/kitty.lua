return {
  'jishnusen/kitty-runner.nvim',
  dev = true,
  config = function()
    require("kitty-runner").setup({
      type = "window"
    })
    local repls = {
      python = "ipython",
      lisp = "rlwrap ros run",
    }
    vim.keymap.set("n", "<C-c><C-r>",
      function()
        local repl = repls[vim.bo.filetype]
        if repl ~= nil then
          require("kitty-runner.kitty-runner").run_command(repl)
        end
      end
    )
    vim.keymap.set("n", "<C-c><C-c>", "vip:KittySendLines<CR>")
    vim.api.nvim_create_autocmd({ "ExitPre" }, {
      pattern = { "*" },
      command = [[KittyKillRunnerSync]],
    })
  end
}
