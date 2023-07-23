local wezterm = require('wezterm')
local keybinds = require('keybinds')
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config = {
	font_size = 12.0,
	-- config.font = wezterm.font('HackGen35Nerd', {}),
	color_scheme = 'tokyonight',

	window_background_opacity = 0.9,
	window_padding = {
        left = 2,
        right = 0,
        top = 0,
        bottom = 0,
    },
    window_decorations = 'RESIZE',

	leader = keybinds.leader,
	disable_default_key_bindings = true,
	keys = keybinds.create_keybinds(),
	key_tables = keybinds.key_tables,

	use_ime = true,
}

return config
