return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
    'sindrets/diffview.nvim',
  },
  cmd = 'Octo',
  keys = {
    { '<leader>op', '<cmd>Octo pr list<cr>', desc = '[O]cto [P]R list' },
    { '<leader>oi', '<cmd>Octo issue list<cr>', desc = '[O]cto [I]ssue list' },
    { '<leader>oc', '<cmd>Octo pr checkout<cr>', desc = '[O]cto [C]heckout PR' },
    { '<leader>od', '<cmd>DiffviewOpen origin/master...HEAD<cr>', desc = '[O]pen [D]iffview vs master' },
  },
  config = function()
    require('octo').setup {
      use_local_fs = false,
      enable_builtin = true,
      default_to_projects_v2 = false,
      picker = 'telescope',
      reviews = {
        auto_show_threads = true,
      },
      file_panel = {
        use_icons = true,
      },
    }
  end,
}
