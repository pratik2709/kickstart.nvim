return {
  'jacobb/annotate.nvim',
  config = function()
    require('annotate').setup {}

    local store = require 'annotate.store'
    local export = require 'annotate.export'
    local original_save = store.save

    store.save = function(...)
      original_save(...)
      export.export()
    end
  end,
}
