-- Completion toggle for blink.cmp
-- Adds <leader>tc to toggle autocomplete on/off (useful when learning a language)

vim.g.blink_cmp_enabled = true

vim.keymap.set('n', '<leader>tc', function()
  vim.g.blink_cmp_enabled = not vim.g.blink_cmp_enabled

  if vim.g.blink_cmp_enabled then
    vim.notify('Autocomplete enabled', vim.log.levels.INFO)
  else
    vim.notify('Autocomplete disabled', vim.log.levels.INFO)
  end
end, { desc = '[T]oggle [C]ompletion' })

return {
  'saghen/blink.cmp',
  opts = {
    enabled = function()
      return vim.g.blink_cmp_enabled
    end,
  },
}
