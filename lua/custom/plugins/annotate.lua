return {
  -- Private fork of jacobb/annotate.nvim with extmark-based tracking.
  url = 'git@github.com:pratik2709/code-annotate.git',
  name = 'annotate.nvim',
  branch = 'feat/extmark-tracking',
  config = function()
    require('annotate').setup { auto_export = true }

    -- Reload files changed on disk (e.g. by an agent) so annotations re-anchor.
    vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
      command = "if mode() != 'c' | checktime | endif",
    })

    local annotation_width = 0.8
    local annotation_height = 15

    -- annotate.nvim currently hardcodes its floating-window dimensions.
    -- Resize only its annotation buffers so other floating windows are unaffected.
    vim.api.nvim_create_autocmd('BufWinEnter', {
      pattern = 'annotate://*',
      callback = function(args)
        local win = vim.fn.bufwinid(args.buf)
        if win == -1 then
          return
        end

        local width = math.floor(vim.o.columns * annotation_width)
        local height = annotation_height
        vim.api.nvim_win_set_config(win, {
          relative = 'editor',
          width = width,
          height = height,
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
        })
      end,
    })
  end,
}
