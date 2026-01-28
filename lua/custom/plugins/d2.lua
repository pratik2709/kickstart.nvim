return {
  'terrastruct/d2-vim',
  ft = { 'd2' },
  config = function()
    -- Enable auto ASCII render on save
    vim.g.d2_ascii_autorender = 1
    -- Set ASCII mode to extended (Unicode box-drawing)
    vim.g.d2_ascii_mode = "extended"
    -- Enable auto format on save
    vim.g.d2_fmt_autosave = 1
    -- Set preview window width to half screen
    vim.g.d2_ascii_preview_width = vim.o.columns / 2
    
    -- Custom keybindings
    -- Normal mode: preview current buffer (for .d2 files)
    vim.keymap.set('n', '<leader>dp', ':D2Preview<CR>', { desc = 'D2 Preview', silent = true })
    
    -- Visual mode: preview selected text (works in any file)
    vim.keymap.set('v', '<leader>dp', ':D2PreviewSelection<CR>', { desc = 'D2 Preview Selection', silent = true })
  end,
}
