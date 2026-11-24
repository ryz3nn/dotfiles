if vim.loader then
  vim.loader.enable()
end

require("ryzc.config.options")
require("ryzc.config.keymaps")
require("ryzc.config.autocmds")
require("ryzc.config.commands")
require("ryzc.config.workarounds")

require("ryzc.plugins")
