return {
  'MerryChaos/package-versions.nvim',
  config = function()
    require('package-versions').setup({
      highlights = {
        ok = "info",
        warning = "todo",
        error = "error",
      },

      autocmds = {
        "BufReadPost",
        "BufWritePost",
      },
    })
  end
}
