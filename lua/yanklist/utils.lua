local M = {}
function M.getYankList()
  local yank_history = vim.fn.execute("reg")
  -- Change yank_history to a table by spltting it by new line
  yank_history = vim.split(yank_history, "\n")

  -- Remove first two lines
  table.remove(yank_history, 1)
  table.remove(yank_history, 1)

  local windowLines = {}
  -- Get only the content of the registers
  for i, v in ipairs(yank_history) do
    local t = {}
    for str in string.gmatch(v, '([^"]+)') do
      table.insert(t, str)
    end
    table.remove(t, 1)
    v = table.concat(t, " ")
    v = v:sub(5)
    v = v:gsub("%^M", "")
    v = vim.split(v, "%^J")
    for _, value in ipairs(v) do
      table.insert(windowLines, value)
    end
  end
  return windowLines
end

return M
