return {
  "nvim-tree/nvim-tree.lua",
  event = "VeryLazy",
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "TreeToggle" },
  },
  config = function()
    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")
      local opts = function(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = false, silent = true, nowait = true }
      end

      vim.keymap.set("n", "<CR>", api.node.open.no_window_picker, opts "Open: No Window Picker")
      vim.keymap.set("n", "O", api.node.open.edit, opts "Open")
    end

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
      },
      on_attach = my_on_attach,
    })
  end
}
