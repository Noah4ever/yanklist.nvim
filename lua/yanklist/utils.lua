local M = {}

function M.get_yanklist()
  local yank_history = vim.fn.execute("reg")

  yank_history = vim.split(yank_history, "\n")

  -- Remove first two lines
  table.remove(yank_history, 1)
  table.remove(yank_history, 1)

  for i, v in ipairs(yank_history) do
    v = string.sub(v, 8) -- remove the first 6 characters

    -- FIX: separator should only be added above the code block if there are more than 2 lines (separator is there to separate code blocks and in the menu it should copy the complete code block and not one line)
    -- local separator = "--sep--"
    -- local lines = vim.split(v, "%^J")
    -- if #lines > 2 then
    --   for j, line in ipairs(lines) do
    --     if j > 1 then
    --       yank_history[i] = separator
    --       i = i + 1
    --       yank_history[i] = line
    --       i = i + 1
    --     else
    --       yank_history[i] = line
    --     end
    --   end
    -- else
    --   yank_history[i] = v
    -- end

    yank_history[i] = v -- replace the value in the table
  end

  return yank_history
end

return M
