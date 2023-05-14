local M = {}
local FILEPATH = vim.fn.stdpath("data") .. "/yank_history.json"
local yank_history = {}

function M.init()
  yank_history = M.read_yank_history() -- read yank history from file
  -- create autocmd for yank
  vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = Save_last_yanked,
  })
end

function Write_yank_history()
  local file = io.open(FILEPATH, "w")
  file:write(vim.fn.json_encode(yank_history))
  file:close()
end

function Save_last_yanked()
  local last_yanked = vim.fn.getreg('"', 1) -- get last yanked item
  if last_yanked == "" then
    return
  end

  last_yanked = vim.split(last_yanked, "\n") -- split at new line (multiline yank)
  if last_yanked[#last_yanked] == "" then   -- remove last item if it is empty
    table.remove(last_yanked, #last_yanked)
  end

  for i, v in ipairs(last_yanked) do
    table.insert(yank_history, i, v) -- insert at the beginning of the table
  end

  if #yank_history > 25 then -- if yank_history is longer than 25 remove last item
    table.remove(yank_history, #yank_history)
  end

  Write_yank_history() -- write to file
end

function M.read_yank_history()
  local file = io.open(FILEPATH, "r")
  if file == nil then
    file = io.open(FILEPATH, "w") -- create file
    file:write("[]")
    file:close()
    return {}
  end
  file:close()
  yank_history = vim.fn.json_decode(file:read("*a"))
  return yank_history
end

function M.get_yank_history()
  return yank_history
end

function M.get_yank_history_item(pos)
  return yank_history[pos]
end

function M.delete_yank_history_item(pos)
  table.remove(yank_history, pos)
  Write_yank_history()
end

return M
