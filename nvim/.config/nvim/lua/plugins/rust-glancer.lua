vim.lsp.config("rust_glancer", {
  cmd = { "rust-glancer", "lsp" },
  filetypes = { "rust" },

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local start_dir = vim.fs.dirname(fname)

    local manifests = vim.fs.find("Cargo.toml", {
      path = start_dir,
      upward = true,
      limit = math.huge,
    })

    local workspace_root

    for _, manifest in ipairs(manifests) do
      local content = table.concat(
        vim.fn.readfile(manifest),
        "\n"
      )

      if content:match("%[workspace%]") then
        workspace_root = vim.fs.dirname(manifest)
      end
    end

    on_dir(
      workspace_root
        or (manifests[1] and vim.fs.dirname(manifests[1]))
        or start_dir
    )
  end,

  init_options = {
    diagnostics = {
      onSave = true,
    },
  },
})

vim.lsp.enable("rust_glancer")
