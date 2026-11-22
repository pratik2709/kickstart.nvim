return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  config = function()
    local cwd = vim.fn.getcwd()
    local project_root = vim.fs.root(cwd, { '.git' }) or cwd

    require('orgmode').setup {
      org_agenda_files = { project_root .. '/**/*.org' },
    }

    require('custom.org_countdown').setup()
    require('custom.org_clock_words').setup()
  end,
}
