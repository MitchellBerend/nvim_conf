local servers = {
  gopls = {
    cmd = { "gopls", "serve" },
    filetypes = { "go", "gomod" },
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
  },

  golangci_lint_ls = {
    cmd = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--timeout", "5m" },
    filetypes = { "go", "gomod" },
  },

  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
      telemetry = { enable = false },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
    },
  },

  templ = {
    cmd = { "templ", "lsp" },
    filetypes = { "tmpl" },
  },
}

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',

    { 'j-hui/fidget.nvim', opts = {}, branch = "legacy" },

    'folke/neodev.nvim',
  },

  config = function()
    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
        '[W]orkspace [S]ymbols')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        local fileName = vim.api.nvim_buf_get_name(0)
        if fileName:endswith(".py") then
          vim.cmd(":retab!")
          vim.cmd(":w")
          vim.cmd(":silent !ruff format " .. fileName)
        elseif fileName:match("%.vue$") or fileName:match("%.ts$") or fileName:match("%.js$") then
          local command = "prettier --write " .. fileName
          vim.fn.system(command)
          vim.cmd("edit") -- Re-read the file after formatting
        else
          vim.lsp.buf.format()
        end
      end, { desc = 'Format current buffer with LSP' })
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    require('mason').setup()

    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        local init_options = {}
        if servers[server_name] and servers[server_name]['init_options'] ~= nil then
          init_options = servers[server_name]['init_options']
        else
          init_options = {}
        end
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          init_options = init_options,
        }
      end,
    }

    local lspconfig = require('lspconfig')

    -- custom gleam lsp setup since it does not work with Mason
    lspconfig.gleam.setup {
      cmd = { "gleam", "lsp" },
      filetypes = { "gleam" },
      capabilities = capabilities,
      on_attach = on_attach
    }

    local mason_registry = require('mason-registry')
    local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
        '/node_modules/@vue/language-server'
    lspconfig.ts_ls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      init_options = {
        plugins = {
          {
            name = '@vue/typescript-plugin',
            location = vue_language_server_path,
            languages = { 'vue' },
          },
        },
      },
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    }

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
      end
    })
  end
}
