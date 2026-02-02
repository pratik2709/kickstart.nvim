return {
  'okuuva/auto-save.nvim',
  version = '^1.0.0',
  event = { 'InsertLeave', 'TextChanged', 'FocusLost', 'BufLeave' },
  keys = {
    { '<leader>ta', '<cmd>ASToggle<CR>', desc = '[T]oggle [A]uto-save' },
  },
  opts = {
    enabled = true,
    trigger_events = {
      -- Save immediately when switching buffers/apps
      immediate_save = { 'BufLeave', 'FocusLost', 'QuitPre', 'VimSuspend' },
      -- Save after 3s delay when editing
      defer_save = { 'InsertLeave', 'TextChanged' },
      cancel_deferred_save = { 'InsertEnter' },
    },
    condition = function(buf)
      local fn = vim.fn
      local filetype = fn.getbufvar(buf, '&filetype')
      local buftype = fn.getbufvar(buf, '&buftype')

      -- Don't save special buffers
      if buftype ~= '' then
        return false
      end

      -- Exclude specific filetypes
      local excluded_filetypes = {
        'gitcommit',
        'gitrebase',
        'NvimTree',
        'TelescopePrompt',
        'toggleterm',
        'alpha',
        'dashboard',
        'lazygit',
        'oil',
        'prompt',
      }

      if vim.tbl_contains(excluded_filetypes, filetype) then
        return false
      end

      return true
    end,
    write_all_buffers = false,
    debounce_delay = 1500, -- 1.5 seconds
    debug = false,
  },
}
