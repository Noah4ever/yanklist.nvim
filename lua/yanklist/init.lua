-- Define the size of the floating window
local width = 50
local height = 10

-- Create the scratch buffer displayed in the floating window
local bufnr = vim.api.nvim_create_buf(false, true)

-- Create the floating window
local opts = {
  relative = "editor",
  width = width,
  height = height,
  -- col = (ui.width / 2) - (width / 2),
  -- row = (ui.height / 2) - (height / 2),
  anchor = "NW",
  style = "minimal",
}
local win = vim.api.nvim_open_win(bufnr, false, {
  relative = "editor",
  -- focusable = false,
  width = width,
  height = height,
  row = 0,
  col = 0,
  anchor = "NW",
  style = "minimal",
  -- noautocmd = true,
})
-- local win = vim.api.nvim_open_win(buf, 1, opts)
