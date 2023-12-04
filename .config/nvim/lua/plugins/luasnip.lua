return {
  "L3MON4D3/LuaSnip",
  version = "v2.1.1",
  build = "make install_jsregexp",
  config = function()
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
  end
}
