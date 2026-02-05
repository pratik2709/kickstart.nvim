-- Completion toggle for blink.cmp
-- Adds <leader>tc to toggle autocomplete on/off (useful when learning a language)

return {
  'saghen/blink.cmp',
  keys = {
    {
      '<leader>tc',
      function()
        local enabled = vim.g.blink_cmp_enabled
        if enabled == nil then
          enabled = true -- default state is enabled
        end
        vim.g.blink_cmp_enabled = not enabled

        if vim.g.blink_cmp_enabled then
          vim.notify('Autocomplete enabled', vim.log.levels.INFO)
        else
          vim.notify('Autocomplete disabled', vim.log.levels.INFO)
        end
      end,
      desc = '[T]oggle [C]ompletion',
    },
  },
  opts = {
    completion = {
      menu = {
        enabled = function()
          -- Check if autocomplete is globally disabled
          local enabled = vim.g.blink_cmp_enabled
          if enabled == nil then
            return true -- default is enabled
          end
          return enabled
        end,
      },
    },
  },
}
