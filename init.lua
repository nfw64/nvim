require("config.options")
require("config.keybinds")
require("config.lazy")

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

for server_name, config in pairs(configs) do
	local cmd = config.default_config and config.default_config.cmd and config.default_config.cmd[1]
	if cmd and vim.fn.executable(cmd) == 1 then
		lspconfig[server_name].setup({})
	end
end
