return {
  'vrischmann/tree-sitter-templ',
  config = function()
    vim.filetype.add({
      extension = {
        templ = "templ",
      },
    })
  end
}
