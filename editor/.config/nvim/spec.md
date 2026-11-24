# 1. Foundation
## 1.1 Folder structure:
    init.lua: enables vim.loader for faster startup, then requires these files directly, in order:
        ryzc.utils, assigned to the global Ryzc
        ryzc.config.options, .keymaps, .autocmds, .commands, .workarounds
        ryzc.plugins
    lua/ryzc/: my config lives here
        utils/: shared helpers
            init.lua: returns a table of helper modules, empty for now.
                Later steps add modules like utils/editor.lua, exposed as editor.
        config/: plain Neovim settings, one file per name above
        plugins/
            init.lua: installs every plugin in one vim.pack.add call, then requires each group file
            Each plugin group gets its own file next to it (e.g. ui.lua), which configures its plugins with require("<plugin>").setup({ ... }).
            keymaps.lua: every keymap that uses a plugin, required last so all plugins are set up first. Group files hold no keymaps.

