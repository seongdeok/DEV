local wezterm = require("wezterm")

if wezterm.target_triple:find("darwin") then
	print("Mac")
elseif wezterm.target_triple:find("linux") then
	print("Linux")
elseif wezterm.target_triple:find("windows") then
	print("Windows")
end

wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	local width = window:get_dimensions().pixel_width

	local overrides = {}
	local screen = window:get_dimensions().pixel_width
	if screen > 3000 then
		overrides.font_size = 16.0
	else
		overrides.font_size = 12.0
	end
	window:set_config_overrides(overrides)
end)

return {
	enable_wayland = false,
	--front_end = "OpenGL",
	front_end = "WebGpu",
	adjust_window_size_when_changing_font_size = false,
	-- color_scheme = 'termnial.sexy',
	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = false,
	font_size = 14.0,
	font = wezterm.font_with_fallback({
		"JetBrains Mono Nerd Font",
		"Hack Nerd Font",
		"Nerd Font",
	}),
	-- macos_window_background_blur = 40,
	--macos_window_background_blur = 30,
	native_macos_fullscreen_mode = false,
	scrollback_lines = 100000,

	window_padding = {
		left = 6,
		right = 6,
		top = 20,
		bottom = 40,
	},
	-- window_background_image = '/Users/omerhamerman/Downloads/3840x1080-Wallpaper-041.jpg',
	-- window_background_image_hsb = {
	-- 	brightness = 0.01,
	-- 	hue = 1.0,
	-- 	saturation = 0.5,
	-- },
	-- window_background_opacity = 0.92,
	--window_background_opacity = 1.0,
	-- window_background_opacity = 0.78,
	-- window_background_opacity = 0.20,
	window_decorations = "RESIZE",
	keys = {
		{
			key = "A",
			mods = "CTRL|SHIFT",
			action = wezterm.action.QuickSelect,
		},
		{
			key = "'",
			mods = "CTRL",
			action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
		},
		{
			key = ",",
			mods = "SUPER",
			action = wezterm.action.SpawnCommandInNewWindow({
				cwd = os.getenv("WEZTERM_CONFIG_DIR"),
				args = { os.getenv("SHELL"), "-c", "$VISUAL $WEZTERM_CONFIG_FILE" },
			}),
		},
	},
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
	default_cursor_style = "BlinkingBar",
	force_reverse_video_cursor = true,
}
