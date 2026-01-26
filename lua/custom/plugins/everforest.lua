return {
  'sainnhe/everforest',
  lazy = false,
  priority = 1000,
  config = function()
    -- Everforest configuration
    vim.g.everforest_background = 'medium' -- 'hard', 'medium', 'soft'
    vim.g.everforest_better_performance = 1
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_disable_italic_comment = 0
    
    -- Uncomment to set as default colorscheme
    -- vim.cmd('colorscheme everforest')
  end,
}
