return {
  "akinsho/bufferline.nvim",
  tag = "v4.4.0",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function(_, opts)
    local bufferline = require("bufferline");
    bufferline.setup({
      options = {
        -- style_preset = bufferline.style_preset.no_italic,
        show_buffer_icons = false,
        buffer_close_icon = '×'
      },
    });
  end,
}
