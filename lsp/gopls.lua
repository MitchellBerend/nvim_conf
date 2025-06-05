return {
  cmd = { 'gopls', 'serve' },
  filetypes = { 'go', 'gomod' },
  root_markers = {
    'go.mod',
  },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      completeUnimported = true,
      usePlaceholders = true,
      staticcheck = true,
    },
  },
}
