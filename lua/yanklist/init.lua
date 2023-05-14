local window = require("yanklist.window")
local manager = require("yanklist.manager")

manager.init()

local Y = {}

-- TODO: optional use telescope menu instead of nui
function Y.open()
  window.open(manager.get_yank_history())
end

return Y
