return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = { 'markdown' },
  keys = {
    { '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', ft = 'markdown', desc = 'Toggle [M]arkdown rendering' },
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    -- Render in normal, command, and terminal modes
    render_modes = { 'n', 'c', 't' },
    heading = {
      -- Full-width heading backgrounds
      width = 'full',
      -- Add a border above/below headings
      border = true,
    },
    code = {
      -- Show language name above code blocks
      language_name = true,
      -- Left-align the language label
      position = 'left',
      width = 'block',
      right_pad = 1,
    },
    anti_conceal = {
      enabled = false,
    },
  },
}
