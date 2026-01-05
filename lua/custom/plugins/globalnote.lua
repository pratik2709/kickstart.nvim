return {
  'backdround/global-note.nvim',
  config = function()
    local global_note = require 'global-note'

    global_note.setup {
      -- Set directory to the Current Working Directory (dynamic)
      directory = function()
        return vim.fn.getcwd()
      end,

      -- This filename will be created inside every project root
      filename = 'project_notes.md',
    }

    -- Standard keybind now opens the local file automatically
    vim.keymap.set('n', '<leader>n', global_note.toggle_note, {
      desc = 'Toggle local project [n]ote',
    })
  end,
}
