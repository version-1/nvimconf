return {
  "mhartington/formatter.nvim",
  keys = {
    { "<leader>i", "<cmd>Format<cr>", desc = "Format" },
    { "<leader>F", "<cmd>FormatWrite<cr>", desc = "Format" },
  },
  config = function()
    -- Utilities for creating configurations
    local util = require "formatter.util"

    -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
    require("formatter").setup {
      -- Enable or disable logging
      logging = true,
      -- Set the log level
      log_level = vim.log.levels.WARN,
      -- All formatter configurations are opt-in
      filetype = {
        -- Formatter configurations for filetype "lua" go here
        -- and will be executed in order
        lua = {
          -- "formatter.filetypes.lua" defines default configurations for the
          -- "lua" filetype
          require("formatter.filetypes.lua").stylua,

          -- You can also define your own configuration
          function()
            -- Supports conditional formatting
            if util.get_current_buffer_file_name() == "special.lua" then
              return nil
            end

            -- Full specification of configurations is down below and in Vim help
            -- files
            return {
              exe = "stylua",
              args = {
                "--search-parent-directories",
                "--stdin-filepath",
                util.escape_path(util.get_current_buffer_file_path()),
                "--",
                "-",
              },
              stdin = true,
            }
          end
        },
        javascript = {
          require("formatter.filetypes.javascript").prettierd,
        },
        typescript = {
          require("formatter.filetypes.typescript").prettierd,
        },
        javascriptreact = {
          require("formatter.filetypes.javascriptreact").prettierd,
        },
        typescriptreact = {
          require("formatter.filetypes.typescriptreact").prettierd,
        },
        json = {
          require("formatter.filetypes.json").prettierd,
        },
        html = {
          require("formatter.filetypes.html").prettierd,
        },
        go = {
          require("formatter.filetypes.go").gofmt,
          require("formatter.filetypes.go").goimports,
        },
        zig = {
          require("formatter.filetypes.zig").zigfmt,
        },
        ruby = {
          require("formatter.filetypes.ruby").rubocop,
        },


        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ["*"] = {
          -- "formatter.filetypes.any" defines default configurations for any
          -- filetype
          require("formatter.filetypes.any").remove_trailing_whitespace,
          require("formatter.filetypes.any").remove_trailing_lines,
        }
      }
    }
  end
}