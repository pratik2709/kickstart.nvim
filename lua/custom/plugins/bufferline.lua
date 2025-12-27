return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  lazy = false,
  keys = {
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '<leader>bl', '<cmd>BufferLineMoveNext<cr>', desc = 'Move Buffer Right' },
    { '<leader>bh', '<cmd>BufferLineMovePrev<cr>', desc = 'Move Buffer Left' },
    { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Buffer Pick' },
  },
  opts = {
    options = {
      mode = 'buffers', -- This makes it look like a standard IDE
      separator_style = 'slant', -- Adds visual "depth"
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          text_align = 'left',
          separator = true,
        },
      },
    },
  },
}
