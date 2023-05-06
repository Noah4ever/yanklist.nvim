local Menu = require("nui.menu")
local M = {}

function foo()
  print("bar") -- test function for yanking multiple lines
end

function M.get_yanklist()
  local yank_history = vim.fn.execute("reg")

  yank_history = vim.split(yank_history, "\n")

  -- Remove first two lines
  table.remove(yank_history, 1)
  table.remove(yank_history, 1)

  local return_list = {}
  local return_list_count = 1
  for i, v in ipairs(yank_history) do
    v = string.sub(v, 11) -- remove the first 6 characters

    -- split at %^J
    local lines = vim.split(v, "%^J")

    -- remove the last line if it is empty
    if lines[#lines] == "" then
      table.remove(lines, #lines)
    end

    -- insert lines into retrn_list
    local insert_code_block_end = false
    for j, line in ipairs(lines) do
      -- if there are more than 2 lines, add a separator
      if #lines > 2 and j == 1 then
        -- start of code block
        return_list[return_list_count] =
            Menu.separator(" Code block — (" .. #lines .. " lines) ", { char = "—", text_align = "left" })
        return_list_count = return_list_count + 1
        insert_code_block_end = true
      end
      return_list[return_list_count] = line
      return_list_count = return_list_count + 1
    end

    if insert_code_block_end then
      -- end of code block
      return_list[return_list_count] = Menu.separator(" Code block end ", { char = "—", text_align = "left" })
      return_list_count = return_list_count + 1
    end
  end

  return return_list
end

return M
