return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function()
    require("oil").setup()
    vim.keymap.set("n", "<F1>", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
