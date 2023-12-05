return {
    "lervag/vimtex",
    version = "^2.13.0",
    config = function()
      vim.g.tex_flavor = "xelatex"
      vim.g.vimtex_compiler_latexmk = {
        ["options"] = {
          "-xelatex",
          "-file-line-error",
          "-interaction=nonstopmode",
          "-shell-escape",
          "-synctex=1",
          "-verbose",
        },
      }
    end,
}
