return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    direction = 'horizontal', -- or 'vertical' / 'float'
    size = 15,
    --    open_mapping = [[<c-\>]], -- This sets Ctrl+\ to open/hide it
    shading_factor = 2,
    float_opts = {
      border = 'curved', -- Gives it that modern "depth" look
    },
  },
}
