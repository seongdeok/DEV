-- ~/.config/yazi/plugins/extra.lua
local M = {}

function M.zoxide_jump()
  local output = os.capture("zoxide query -i")
  if output and output ~= "" then
    ya.manager_cd(output)
  end
end

return M

