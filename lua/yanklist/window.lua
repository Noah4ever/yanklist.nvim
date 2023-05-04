local utils = require("yanklist.utils")
local M = {}

local function create_yanklist_buf()
  local buf = vim.api.nvim_create_buf(false, true)

  local yanklist = utils.getYankList()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, yanklist)

  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "yanklist")
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "readonly", true)
  vim.api.nvim_buf_set_option(buf, "buflisted", false)
  vim.api.nvim_buf_set_option(buf, "undolevels", -1)

  return buf
end

local function create_yanklist_win(buf)
  local ui = vim.api.nvim_list_uis()[1]

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

  vim.api.nvim_buf_set_name(buf, "Yanklist")
  vim.cmd("highlight default link YanklistTitle Title")
  vim.cmd("highlight default link YanklistYank Yanklist")
  vim.cmd("highlight default link YanklistYankCurrent YanklistCurrent")
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })

  return win
end

function M.open()
  local yanklist_buf = create_yanklist_buf()
  local yanklist_win = create_yanklist_win(yanklist_buf)
end

return M
