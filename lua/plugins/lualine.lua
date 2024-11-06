return {
  'nvim-lualine/lualine.nvim',
  config = function()
    -- local theme = require 'lualine.themes.tokyonight'
    -- theme.normal.c.bg = nil

    require('lualine').setup({
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          {
            'filename',
            file_status = true,
            path = 1,
            shorting_target = 40,
          },
          'diagnostics',
        },
        lualine_c = { 'branch' },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      options = {
        theme = 'nord',
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {
          {
            'filename',
            file_status = true,
            path = 1,
            shorting_target = 40,
          },
        },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
    })
  end
}
