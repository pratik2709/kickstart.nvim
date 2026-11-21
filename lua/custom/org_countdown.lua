-- Countdown timer shown as virtual text at the end of an org heading.
-- Starting a countdown clocks in (nvim-orgmode), stopping clocks out.
-- Past zero it keeps counting as overtime until stopped.

local M = {}

local ns = vim.api.nvim_create_namespace 'org_countdown'
local default_minutes = 25

---@type { buf: integer, mark: integer, ends_at: integer, title: string, notified: boolean, timer: uv.uv_timer_t }|nil
local active = nil

vim.api.nvim_set_hl(0, 'OrgCountdown', { default = true, link = 'DiagnosticInfo' })
vim.api.nvim_set_hl(0, 'OrgCountdownLow', { default = true, link = 'DiagnosticWarn' })
vim.api.nvim_set_hl(0, 'OrgCountdownOver', { default = true, link = 'DiagnosticError' })

--- Parses `10` (minutes), `90s`, `10m`, `1h`, or org-style `H:MM` into seconds.
local function parse_duration(str)
  str = vim.trim(str or '')
  if str == '' then
    return nil
  end
  local h, m = str:match '^(%d+):(%d%d)$'
  if h then
    return tonumber(h) * 3600 + tonumber(m) * 60
  end
  local n, unit = str:match '^(%d+)%s*([smh]?)$'
  if not n then
    return nil
  end
  return tonumber(n) * ({ s = 1, m = 60, h = 3600, [''] = 60 })[unit]
end

local function format_secs(secs)
  local h, m, s = math.floor(secs / 3600), math.floor(secs % 3600 / 60), secs % 60
  if h > 0 then
    return string.format('%d:%02d:%02d', h, m, s)
  end
  return string.format('%02d:%02d', m, s)
end

local function notify(msg)
  vim.notify(msg, vim.log.levels.WARN, { title = 'Org countdown' })
  if vim.fn.has 'mac' == 1 then
    vim.system {
      'osascript',
      '-e',
      string.format('display notification %q with title "Org countdown" sound name "Glass"', msg),
    }
  end
end

local function mark_row()
  local pos = vim.api.nvim_buf_get_extmark_by_id(active.buf, ns, active.mark, {})
  return pos[1]
end

local function render()
  if not active then
    return
  end
  if not vim.api.nvim_buf_is_valid(active.buf) then
    return M.stop { clock_out = false }
  end

  local left = active.ends_at - os.time()
  local text, hl
  if left > 0 then
    text, hl = '⏳ ' .. format_secs(left), left <= 60 and 'OrgCountdownLow' or 'OrgCountdown'
  else
    text, hl = '⏰ +' .. format_secs(-left), 'OrgCountdownOver'
    if not active.notified then
      active.notified = true
      notify(string.format('Time is up: %s', active.title))
    end
  end

  vim.api.nvim_buf_set_extmark(active.buf, ns, mark_row(), 0, {
    id = active.mark,
    virt_text = { { text, hl } },
    virt_text_pos = 'eol',
  })
end

--- True if an orgmode headline (from an event) is the one we are counting down on.
local function is_active_headline(headline)
  if not active or not vim.api.nvim_buf_is_valid(active.buf) then
    return false
  end
  local ok, start_line = pcall(function()
    return headline:get_range().start_line
  end)
  local same_file = vim.fs.normalize(headline.file.filename) == vim.fs.normalize(vim.api.nvim_buf_get_name(active.buf))
  return ok and same_file and start_line == mark_row() + 1
end

---@param opts? { clock_out?: boolean }
function M.stop(opts)
  if not active then
    return
  end
  local stopped = active
  active = nil
  stopped.timer:stop()
  stopped.timer:close()
  if vim.api.nvim_buf_is_valid(stopped.buf) then
    vim.api.nvim_buf_del_extmark(stopped.buf, ns, stopped.mark)
    if (opts or {}).clock_out ~= false then
      require('orgmode').action 'clock.org_clock_out'
    end
  end
end

local function start_on_heading(row, title, secs)
  M.stop { clock_out = false }

  local buf = vim.api.nvim_get_current_buf()
  active = {
    buf = buf,
    mark = vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {}),
    ends_at = os.time() + secs,
    title = title,
    notified = false,
    timer = vim.uv.new_timer(),
  }
  active.timer:start(0, 1000, vim.schedule_wrap(render))
end

--- Starts a countdown on the heading at or above the cursor.
--- Duration: `arg`, else the heading's Effort property, else a prompt (default 25 min).
function M.start(arg)
  local ok, headline = pcall(function()
    return require('orgmode.api').current():get_closest_headline()
  end)
  if not ok then
    return vim.notify(tostring(headline), vim.log.levels.ERROR)
  end
  if not headline then
    return vim.notify('No org heading above the cursor', vim.log.levels.ERROR)
  end

  local function begin(secs)
    -- Clock in first: it may clock out another heading, which fires a
    -- clocked_out event that must not cancel the countdown we start here.
    require('orgmode').action 'clock.org_clock_in'
    start_on_heading(headline.position.start_line - 1, headline.title, secs)
  end

  if arg and arg ~= '' then
    local secs = parse_duration(arg)
    if not secs then
      return vim.notify('Invalid duration: ' .. arg, vim.log.levels.ERROR)
    end
    return begin(secs)
  end

  local effort_secs = parse_duration(headline:get_property 'Effort')
  if effort_secs then
    return begin(effort_secs)
  end

  vim.ui.input({ prompt = string.format('Countdown (default %d min): ', default_minutes) }, function(input)
    if input == nil then
      return
    end
    local secs = input == '' and default_minutes * 60 or parse_duration(input)
    if not secs then
      return vim.notify('Invalid duration: ' .. input, vim.log.levels.ERROR)
    end
    begin(secs)
  end)
end

function M.setup()
  local events = require 'orgmode.events'
  local types = require 'orgmode.events.types'

  -- Clocking out (<leader>oxo) or marking the heading DONE ends the countdown.
  events.listen(types.ClockedOut, function(event)
    if is_active_headline(event.headline) then
      M.stop { clock_out = false }
    end
  end)
  events.listen(types.TodoChanged, function(event)
    if event.headline:is_done() and is_active_headline(event.headline) then
      M.stop()
    end
  end)

  vim.api.nvim_create_user_command('OrgCountdown', function(cmd)
    M.start(cmd.args)
  end, { nargs = '?', desc = 'Start a countdown on the current org heading' })
  vim.api.nvim_create_user_command('OrgCountdownStop', function()
    M.stop()
  end, { desc = 'Stop the org countdown and clock out' })

  local function set_keymaps(buf)
    vim.keymap.set('n', '<leader>oxt', M.start, { buffer = buf, desc = 'org countdown start' })
    vim.keymap.set('n', '<leader>oxs', M.stop, { buffer = buf, desc = 'org countdown stop' })
  end
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'org',
    callback = function(ev)
      set_keymaps(ev.buf)
    end,
  })
  -- orgmode loads on VeryLazy, so org buffers opened at startup already exist.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == 'org' then
      set_keymaps(buf)
    end
  end
end

return M
