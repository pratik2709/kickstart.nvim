return {
  {
    'nvim-lua/plenary.nvim', -- Just a safe plugin to hook into lazy.nvim's system
    lazy = false,
    config = function()
      vim.filetype.add {
        extension = {
          wgsl = 'wgsl',
        },
      }
    end,
  },
}
