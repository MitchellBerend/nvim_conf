local vim = vim
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

vim.lsp.config("*", {
  capabilities = capabilities,
  single_file_support = true,
  root_markers = { ".git" },
})

local nmap = function(keybind, func, desc, ev)
  vim.keymap.set('n', keybind, func, { buffer = ev.buf, desc = desc })
end

local nmap_opt = function(keybind, func, opt)
  vim.keymap.set('n', keybind, func, opt)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame', ev)
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', ev)

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition', ev)
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences', ev)
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation', ev)
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition', ev)
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols', ev)
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
      '[W]orkspace [S]ymbols', ev)

    nmap_opt('K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'Hover Documentation' })

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', ev)
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder', ev)
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder', ev)
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders', ev)

    vim.api.nvim_buf_create_user_command(ev.buf, 'Format', function(_)
      local fileName = vim.api.nvim_buf_get_name(0)
      if fileName:endswith(".py") then
        vim.cmd(":retab!")
        vim.cmd(":w")
        vim.cmd(":silent !ruff format " .. fileName)
      elseif fileName:match("%.vue$") or fileName:match("%.ts$") or fileName:match("%.js$") then
        vim.cmd(":w")
        local command = "prettier --write " .. fileName
        vim.fn.system(command)
        vim.cmd("edit")
      else
        vim.lsp.buf.format()
      end
    end, { desc = 'Format current buffer with LSP' })
  end,
})

local config_keys = {}
local packages = require("mason-registry").get_installed_packages()
for _, pkg in ipairs(packages) do
  for i = 1, #pkg.spec.categories do
    if pkg.spec.categories[i] == "LSP" then
      if vim.lsp.config[pkg.name] == nil then
        print("LSP config for " .. pkg.name .. " not found.")
      else
        table.insert(config_keys, pkg.name)
      end
      break
    end
  end
end
vim.lsp.enable(config_keys)

vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
  end
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.py',
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
  end
})
