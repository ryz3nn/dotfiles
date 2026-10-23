vim.lsp.enable("rust_glancer")
return {
local rust_glancer_config =
  vim.api.nvim_get_runtime_file("after/lsp/rust_glancer.lua", false)[1]

if rust_glancer_config then
  local config = dofile(rust_glancer_config)
  vim.lsp.config("rust_glancer", config)
  vim.lsp.enable("rust_glancer")
else
  vim.notify("rust_glancer.lua config not found", vim.log.levels.ERROR)
end
}
