local M = {}

function M.open()
  -- Define the size of the flodating window
  local width = 50
  local height = 10

  -- Create the scratch buffer displayed in the floating window
  local buf = vim.api.nvim_create_buf(false, true)

  local yank_history = vim.fn.execute("reg")
  -- Change yank_history to a table
  yank_history = vim.split(yank_history, "\n")
  -- Remove the first line
  table.remove(yank_history, 1)
  table.remove(yank_history, 2)
  -- Get only the content of the registers
  for i, v in ipairs(yank_history) do
    print("asd", v)
    yank_history[i] = vim.split(v, '"')[2]
  end

  print(vim.inspect(yank_history))

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, yank_history)

  -- Create the floating window
  local ui = vim.api.nvim_list_uis()[1]

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
end

return M
