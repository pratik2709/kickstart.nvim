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
    { '<leader>bd', '<cmd>BufferLinePickClose<cr>', desc = '[B]uffer [D]elete (Pick)' },
    { '<leader>bc', '<cmd>BufferLineCloseOthers<cr>', desc = '[B]uffer [C]lose Others' },
    { '<leader>bx', function()
      local buf = vim.api.nvim_get_current_buf()
      local buffers = vim.fn.getbufinfo({ buflisted = 1 })
      
      -- If this is the last buffer, just delete it
      if #buffers <= 1 then
        vim.cmd('bdelete')
        return
      end
      
      -- Try to go to next buffer, fallback to previous
      local ok = pcall(vim.cmd, 'BufferLineCycleNext')
      if not ok then
        pcall(vim.cmd, 'BufferLineCyclePrev')
      end
      
      -- Delete the original buffer
      vim.cmd('bdelete ' .. buf)
    end, desc = 'Close Current Buffer' },
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
