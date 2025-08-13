return {
  "neovim/nvim-lspconfig",
  config = function()
    -- ref: https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/lspconfig.lua
    local M = {}
    local map = vim.keymap.set

    -- export on_attach & capabilities
    M.on_attach = function(_, bufnr)
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
      -- map("n", "<leader>ra", require "nvchad.lsp.renamer", opts "NvRenamer")

      map({ "n", "v" }, "<leader>ca", buf.code_action, opts "Code action")
      map("n", "gr", buf.references, opts "Show references")
    end

    -- disable semanticTokens
    M.on_init = function(client, _)
      if client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end

    M.capabilities = vim.lsp.protocol.make_client_capabilities()

    M.capabilities.textDocument.completion.completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    }

    M.defaults = function()
      -- dofile(vim.g.base46_cache .. "lsp")
      -- require("nvchad.lsp").diagnostic_config()

      require("lspconfig").lua_ls.setup {
        on_attach = M.on_attach,
        capabilities = M.capabilities,
        on_init = M.on_init,

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
      }

      require("lspconfig").ts_ls.setup({})
      require("lspconfig").phpactor.setup({})
      require("lspconfig").gopls.setup({})
      require("lspconfig").ruby_lsp.setup({})
      require("lspconfig").ziggy.setup({})
    end

    M.defaults()
  end
}
