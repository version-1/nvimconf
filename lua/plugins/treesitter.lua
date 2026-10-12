local parsers = {
  "ruby",
  "php",
  "go",
  "gotmpl",
  "gomod",
  "gosum",
  "zig",
  "tsx",
  "javascript",
  "typescript",
  "json",
  "html",
  "css",
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "markdown_inline",
  "markdown",
  "sql",
  "yaml",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "graphql",
  "c",
  "cpp",
  "c_sharp",
}

local configured_parsers = {}
for _, parser in ipairs(parsers) do
  configured_parsers[parser] = true
end

local function start_highlight(bufnr)
  local ok, language = pcall(vim.treesitter.language.get_lang, vim.bo[bufnr].filetype)
  if ok and configured_parsers[language] then
    pcall(vim.treesitter.start, bufnr)
  end
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup {}

    local group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        start_highlight(args.buf)
      end,
    })

    treesitter.install(parsers):await(function(err, success)
      if err or not success then
        vim.notify("nvim-treesitter parser installation failed", vim.log.levels.WARN)
      end

      vim.schedule(function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(bufnr) then
            start_highlight(bufnr)
          end
        end
      end)
    end)
  end,
}
