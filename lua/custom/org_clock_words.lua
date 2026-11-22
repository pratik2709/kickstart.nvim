-- Shows org CLOCK lines in words (display only, the file is untouched):
--   CLOCK: [2026-11-22 Sun 16:46]--[2026-11-22 Sun 16:48] =>  0:02
-- is drawn as
--   ⏱ 2 minutes · Sun 22 Nov, 16:46
-- and each :LOGBOOK: line gets the total. <leader>oxr toggles the raw text.

local M = {}

local ns = vim.api.nvim_create_namespace 'org_clock_words'

vim.api.nvim_set_hl(0, 'OrgClockWordsDuration', { default = true, link = 'DiagnosticInfo' })
vim.api.nvim_set_hl(0, 'OrgClockWordsDate', { default = true, link = 'Comment' })
vim.api.nvim_set_hl(0, 'OrgClockWordsTotal', { default = true, link = 'Comment' })

local function plural(n, word)
  return string.format('%d %s%s', n, word, n == 1 and '' or 's')
end

local function in_words(minutes)
  if minutes == 0 then
    return 'under a minute'
  end
  local h, m = math.floor(minutes / 60), minutes % 60
  if h == 0 then
    return plural(m, 'minute')
  end
  return m == 0 and plural(h, 'hour') or plural(h, 'hour') .. ' ' .. plural(m, 'minute')
end

--- Parses a CLOCK line. Returns nil if it is not one.
---@return { indent: integer, start: string, minutes?: integer }|nil
local function parse_clock(line)
  local indent, y, mo, d, dow, hh, mm = line:match '^(%s*)CLOCK:%s*%[(%d+)%-(%d+)%-(%d+) (%a+) (%d+):(%d+)%]'
  if not indent then
    return nil
  end
  local month = os.date('%b', os.time { year = tonumber(y), month = tonumber(mo), day = tonumber(d), hour = 12 })
  local eh, em = line:match '=>%s*(%d+):(%d+)%s*$'
  return {
    indent = #indent,
    start = string.format('%s %d %s, %s:%s', dow, tonumber(d), month, hh, mm),
    minutes = eh and tonumber(eh) * 60 + tonumber(em) or nil,
  }
end

local function render(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  if vim.b[buf].org_clock_raw then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local logbook_row, total, has_closed = nil, 0, false

  for i, line in ipairs(lines) do
    local row = i - 1
    if line:match '^%s*:LOGBOOK:%s*$' then
      logbook_row, total, has_closed = row, 0, false
    elseif line:match '^%s*:END:%s*$' and logbook_row then
      -- A drawer with only a running clock has no total yet.
      if has_closed then
        vim.api.nvim_buf_set_extmark(buf, ns, logbook_row, 0, {
          virt_text = { { 'total ' .. in_words(total), 'OrgClockWordsTotal' } },
          virt_text_pos = 'eol',
        })
      end
      logbook_row = nil
    else
      local clock = parse_clock(line)
      if clock then
        has_closed = has_closed or clock.minutes ~= nil
        local duration = clock.minutes and in_words(clock.minutes) or 'running'
        local date = clock.minutes and (' · ' .. clock.start) or (' since ' .. clock.start)
        total = total + (clock.minutes or 0)

        -- Overlay draws over the raw text; pad with spaces so none of it shows through.
        local width = vim.fn.strdisplaywidth(line) - clock.indent
        local text_width = vim.fn.strdisplaywidth('⏱ ' .. duration .. date)
        vim.api.nvim_buf_set_extmark(buf, ns, row, clock.indent, {
          virt_text = {
            { '⏱ ' .. duration, 'OrgClockWordsDuration' },
            { date, 'OrgClockWordsDate' },
            { string.rep(' ', math.max(0, width - text_width)) },
          },
          virt_text_pos = 'overlay',
          hl_mode = 'combine',
        })
      end
    end
  end
end

local function toggle_raw()
  local buf = vim.api.nvim_get_current_buf()
  vim.b[buf].org_clock_raw = not vim.b[buf].org_clock_raw
  render(buf)
end

local function attach(buf)
  if vim.b[buf].org_clock_words_attached then
    return
  end
  vim.b[buf].org_clock_words_attached = true

  vim.keymap.set('n', '<leader>oxr', toggle_raw, { buffer = buf, desc = 'org clock: toggle raw CLOCK lines' })

  local pending = false
  vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'TextChangedI' }, {
    buffer = buf,
    callback = function()
      if pending then
        return
      end
      pending = true
      vim.schedule(function()
        pending = false
        if vim.api.nvim_buf_is_valid(buf) then
          render(buf)
        end
      end)
    end,
  })
  render(buf)
end

function M.setup()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'org',
    callback = function(ev)
      attach(ev.buf)
    end,
  })
  -- orgmode loads on VeryLazy, so org buffers opened at startup already exist.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == 'org' then
      attach(buf)
    end
  end
end

return M
