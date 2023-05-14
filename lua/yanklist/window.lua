local M = {}

function M.open(yanklist)
  local Menu = require("nui.menu")

  local lines = {}
  -- create a list of lines
  for _, v in ipairs(yanklist) do
    table.insert(lines, Menu.item(v))
  end

  -- create a new menu
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
      print('Yanked to "" and "+: ', item.text)
    end,
  })

  -- mount the component
  menu:mount()
end

return M
