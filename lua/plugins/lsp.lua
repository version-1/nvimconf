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

    local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if has_cmp_nvim_lsp then
      M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
    end

    M.defaults = function()
      -- dofile(vim.g.base46_cache .. "lsp")
      -- require("nvchad.lsp").diagnostic_config()

      local default_server_opts = {
        on_attach = M.on_attach,
        capabilities = M.capabilities,
        on_init = M.on_init,
      }

      vim.lsp.config("lua_ls", {
        on_attach = default_server_opts.on_attach,
        capabilities = default_server_opts.capabilities,
        on_init = default_server_opts.on_init,

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

      vim.lsp.config("ts_ls", default_server_opts)
      vim.lsp.config("phpactor", vim.tbl_extend("force", default_server_opts, {
        cmd = { "phpactor", "language-server" },
        filetypes = { "php" },
      }))
      vim.lsp.config("gopls", default_server_opts)
      vim.lsp.config("ruby_lsp", default_server_opts)
      vim.lsp.config("ziggy", default_server_opts)

      vim.lsp.enable "lua_ls"
      vim.lsp.enable "ts_ls"
      vim.lsp.enable "phpactor"
      vim.lsp.enable "gopls"
      vim.lsp.enable "ruby_lsp"
      vim.lsp.enable "ziggy"
    end

    M.defaults()
  end
}
