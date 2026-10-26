return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPre', 'BufNewFile' }, -- Loads when opening a file rather than blocking startup
  config = function()
    local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
    if not status_ok then
      return
    end

    configs.setup({
      ensure_installed = {
        'c', -- Essential for Neovim Treesitter base
        'lua',
        'python',
        'javascript',
        'vimdoc',
        'vim',
        'regex',
        'sql',
        'dockerfile',
        'toml',
        'json',
        'go',
        'gitignore',
        'graphql',
        'yaml',
        'make',
        'cmake',
        'markdown',
        'markdown_inline',
        'bash',
        'css',
        'html',
        'rust',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    })
  end,
}
