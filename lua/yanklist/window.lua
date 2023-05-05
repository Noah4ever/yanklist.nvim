local utils = require("yanklist.utils")
local M = {}

function M.open()
  local Menu = require("nui.menu")
  local event = require("nui.utils.autocmd").event
  local yanklist = utils.get_yanklist()
  local lines = {}
  for _, v in ipairs(yanklist) do
    -- TODO: if v == 'some escape char for separator' then insert separator
    -- TODO: onclick ON separator copy all sub items to clipboard
    table.insert(lines, Menu.item(v))
  end

  local menu = Menu({
    position = "50%",
    size = {
      width = 100,
      height = 25,
    },
    border = {
      style = "rounded",
      text = {
        top = " Yanklist ",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = lines,
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>", "q" },
      submit = { "<CR>", "<Space>" },
    },
    on_close = function()
      -- Nothing
    end,
    on_submit = function(item)
      vim.fn.setreg("+", item.text)
      vim.fn.setreg("", item.text)
      print('Yanked to "" and "+: ', string.gsub(item.text, "^%s*(.-)%s*$", "%1"))
    end,
  })

  -- mount the component
  menu:mount()
end

return M
