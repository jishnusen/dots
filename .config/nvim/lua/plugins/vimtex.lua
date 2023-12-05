return {
    "lervag/vimtex",
    version = "^2.13.0",
    config = function()
      vim.g.vimtex_view_method = "zathura";
      vim.g.tex_flavor = "latex";
      vim.g.vimtex_view_forward_search_on_start = false;
      vim.g.vimtex_compiler_latexmk = {
        ["executable"] = "latexmk",
        ["options"] = {
          "-pdf",
          "-file-line-error",
          "-interaction=nonstopmode",
          "-shell-escape",
          "-synctex=1",
          "-verbose",
        },
      }
    end,
};
