return {
  "nvim-tree/nvim-tree.lua",
  event = "VeryLazy",
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "TreeToggle" },
  },
  config = function()
    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")
      local map = vim.keymap.set
      local opts = function(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = false, silent = true, nowait = true }
      end
      api.config.mappings.default_on_attach(bufnr)

      map("n", "<CR>", api.node.open.no_window_picker, opts "Open: No Window Picker")
      map("n", "O", api.node.open.edit, opts "Open")
      map("n", "X", api.fs.cut, opts "Cut")
      map("n", "x", api.node.navigate.parent_close, opts "Parent Close")
      vim.keymap.del("n", "<C-e>", { buffer = bufnr })
    end

    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
      },
      git = {
        enable = true,
      },
      modified = {
        enable = true,
      },
      on_attach = my_on_attach,
    })
  end
}
