local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "folke/tokyonight.nvim", lazy = false },
  { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
  { "folke/neodev.nvim", opts = {} },
  { "neovim/nvim-lspconfig" },
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' }},
  { "L3MON4D3/LuaSnip", version = "v2.1.1", build = "make install_jsregexp" },
  { "hrsh7th/nvim-cmp", event = { "InsertEnter", "CmdLineEnter" },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
    },
  },
})
require("tokyonight").setup({
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
  },
});
local bufferline = require("bufferline");
bufferline.setup({
  options = {
    style_preset = {
      bufferline.style_preset.no_italic,
    },
  },
});
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
local types = require("luasnip.util.types")
-- Loads in snippets
require("luasnip.loaders.from_lua").load({
  paths = vim.fn["stdpath"]("config") .. "/luasnippets/",
})
require("luasnip").config.set_config({
  update_events = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<- Choice" } },
      },
    },
  },
})

local cmp = require('cmp');
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
});

-- appearance
vim.cmd.colorscheme("tokyonight-night")
vim.wo.number = true

-- keymappings
vim.g.mapleader = ","
local function noremap(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command, { noremap = true })
end
noremap("n", "j", "gj")
noremap("n", "k", "gk")
noremap("n", "J", "5gj")
noremap("n", "K", "5gk")
noremap("n", "L", "$")
noremap("n", "H", "^")
noremap("n", "<Leader><Leader>", ":bn<CR>")
noremap("n", "<Leader>.", ":bp<CR>")
noremap("n", "<Leader>w", ":bd<CR>")

-- indent behavior
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
