return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "folke/neodev.nvim",
    "folke/trouble.nvim",
    "nvim-tree/nvim-web-devicons", -- trouble.nvim
  },
  config = function()
    require("neodev").setup({});
    local lspconfig = require('lspconfig');
    lspconfig.pyright.setup({});
    lspconfig.tsserver.setup({});
    lspconfig.texlab.setup({
      settings = {
        texlab = {
          build = {
            onSave = true,
            executable = "latexmk",
            args = {
              "-xelatex",
              "-synctex=1",
              "-interaction=nonstopmode",
              "-file-line-error",
              "--shell-escape",
              "%f"
            }
          }
        }
      }
    });
    lspconfig.clangd.setup({
      single_file_support = true,
    });
    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          }
        }
      }
    });
  end
}
