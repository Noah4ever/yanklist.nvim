local yanklist = require("yanklist")

-- create user command to open yanklist window
vim.api.nvim_create_user_command("YankList", "lua require('yanklist').open()", {})
-- How do i use the command? :YankList
-- I get an error Not an editor command: YankList when i use it, What do i do?
-- You need to source the file, or restart nvim.
-- You can source the file by running :source % in the file, or by restarting nvim.
