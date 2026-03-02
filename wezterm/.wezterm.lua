-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Front-end
config.front_end = "Software"
config.max_fps = 30
config.scrollback_lines = 3500 -- Keep this reasonable
config.enable_tab_bar = false   -- Tab bars can sometimes add overhead

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 10
config.color_scheme = 'AdventureTime'

-- Finally, return the configuration to wezterm:
return config
