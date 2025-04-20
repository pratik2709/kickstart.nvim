return {
  'nvim-treesitter/nvim-treesitter',
  opts = function(_, opts)
    -- Add WGSL to the list of ensured parsers
    opts.ensure_installed = opts.ensure_installed or {}
    if not vim.tbl_contains(opts.ensure_installed, 'wgsl') then
      table.insert(opts.ensure_installed, 'wgsl')
    end
  end,
}
