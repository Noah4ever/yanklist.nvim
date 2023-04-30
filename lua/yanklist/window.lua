local M = {}

function M.open()
  -- Define the size of the flodating window
  local width = 50
  local height = 10

  -- Create the scratch buffer displayed in the floating window
  local bufnr = vim.api.nvim_create_buf(false, true)

  -- Create the floating window
  local ui = vim.api.nvim_list_uis()[1]

  local win = vim.api.nvim_open_win(bufnr, true, {
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
