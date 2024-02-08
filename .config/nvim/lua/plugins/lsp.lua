return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "folke/neodev.nvim",
    "folke/trouble.nvim",
    "nvim-tree/nvim-web-devicons", -- trouble.nvim
    "onsails/lspkind.nvim",
    "ray-x/lsp_signature.nvim",
  },
  config = function()
    require("mason").setup();
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

    require("lsp_signature").setup({})
    require("lspkind").init({})

    vim.diagnostic.config({
      update_in_insert = true,
    });
  end
}
