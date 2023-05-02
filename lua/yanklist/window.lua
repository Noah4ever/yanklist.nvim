local utils = require("yanklist.utils")
local M = {}

function M.open()
  -- Create the scratch buffer displayed in the floating window
  local buf = vim.api.nvim_create_buf(false, true)

  local yanklist = utils.getYankList()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, yanklist)

  -- Create the floating window
  local ui = vim.api.nvim_list_uis()[1]

  -- set title of window
  vim.api.nvim_buf_set_name(buf, "Yanklist")

  -- set options
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "yanklist")
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "readonly", true)
  vim.api.nvim_buf_set_option(buf, "buflisted", false)
  vim.api.nvim_buf_set_option(buf, "undolevels", -1)

  -- set highlight
  vim.cmd("highlight default link YanklistTitle Title")
  vim.cmd("highlight default link YanklistYank Yanklist")
  vim.cmd("highlight default link YanklistYankCurrent YanklistCurrent")

  -- set keymap
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })

  -- Define the size of the flodating window
  local width = 100
  local height = 25

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (ui.width / 2) - (width / 2),
    row = (ui.height / 2) - (height / 2),
    anchor = "NW",
    style = "minimal",
    border = "rounded",
  })
  -- set title
  -- TODO: Title is not beeing closed when main window is closed (AutoCmd is not working correctly)
  -- Add_title_to_win(win, "Yanklist")
end

local winid_map = {}
function Add_title_to_win(winid, title, opts)
  opts = opts or {}
  opts.align = opts.align or "center"
  if not vim.api.nvim_win_is_valid(winid) then
    return
  end
  -- HACK to force the parent window to position itself
  -- See https://github.com/neovim/neovim/issues/13403
  vim.cmd("redraw")
  local width = math.min(vim.api.nvim_win_get_width(winid) - 4, 2 + vim.api.nvim_strwidth(title))
  local title_winid = winid_map[winid]
  local bufnr
  if title_winid and vim.api.nvim_win_is_valid(title_winid) then
    vim.api.nvim_win_set_width(title_winid, width)
    bufnr = vim.api.nvim_win_get_buf(title_winid)
  else
    bufnr = vim.api.nvim_create_buf(false, true)
    local col = 1
    if opts.align == "center" then
      col = math.floor((vim.api.nvim_win_get_width(winid) - width) / 2)
    elseif opts.align == "right" then
      col = vim.api.nvim_win_get_width(winid) - 1 - width
    elseif opts.align ~= "left" then
      vim.notify(string.format("Unknown dressing window title alignment: '%s'", opts.align), vim.log.levels.ERROR)
    end
    title_winid = vim.api.nvim_open_win(bufnr, false, {
      relative = "win",
      win = winid,
      width = width,
      height = 1,
      row = -1,
      col = col,
      focusable = false,
      zindex = 151,
      style = "minimal",
      noautocmd = true,
    })
    winid_map[winid] = title_winid
    vim.api.nvim_win_set_option(title_winid, "winblend", vim.api.nvim_win_get_option(winid, "winblend"))
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    vim.cmd(string.format(
      [[
      autocmd WinClosed <buffer=%d> ++nested ++once lua pcall(vim.api.nvim_win_close, %d, true)
      ]],
      bufnr,
      title_winid
    ))
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, { " " .. title .. " " })
  local ns = vim.api.nvim_create_namespace("DressingWindow")
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  vim.api.nvim_buf_add_highlight(bufnr, ns, "FloatTitle", 0, 0, -1)
end

return M
