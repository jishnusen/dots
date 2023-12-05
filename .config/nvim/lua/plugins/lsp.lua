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
    lspconfig.texlab.setup({
      settings = {
        texlab = {
          build = {
            onSave = false,
            executable = "latexmk",
            args = {
              "-pdf",
              "-xelatex",
              "-interaction=nonstopmode",
              "--shell-escape",
              "%f"
            }
          },
          chktex = {
            onOpenAndSave = true,
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

    vim.diagnostic.config({
      update_in_insert = true,
    });
  end
}
