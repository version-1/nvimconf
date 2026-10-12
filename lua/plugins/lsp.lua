return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local map = vim.keymap.set

    local on_attach = function(_, bufnr)
      local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
      end

      local buf = vim.lsp.buf
      map("n", "gD", buf.declaration, opts "Go to declaration")
      map("n", "gd", buf.definition, opts "Go to definition")
      map("n", "gi", buf.implementation, opts "Go to implementation")
      map("n", "<leader>sh", buf.signature_help, opts "Show signature help")
      map("n", "<leader>wa", buf.add_workspace_folder, opts "Add workspace folder")
      map("n", "<leader>wr", buf.remove_workspace_folder, opts "Remove workspace folder")
      map("n", "<leader>wl", function()
        print(vim.inspect(buf.list_workspace_folders()))
      end, opts "List workspace folders")
      map("n", "<leader>D", buf.type_definition, opts "Go to type definition")
      map({ "n", "v" }, "<leader>ca", buf.code_action, opts "Code action")
      map("n", "gr", buf.references, opts "Show references")
    end

    local on_init = function(client, _)
      if client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end

    vim.lsp.config("*", {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              vim.fn.expand "$VIMRUNTIME/lua",
              vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
              vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
              vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
              "${3rd}/luv/library",
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    })

    vim.lsp.config("phpactor", {
      cmd = { "phpactor", "language-server" },
      filetypes = { "php" },
    })

    for _, server in ipairs({ "lua_ls", "ts_ls", "phpactor", "gopls", "ruby_lsp", "ziggy" }) do
      vim.lsp.enable(server)
    end
  end,
}
