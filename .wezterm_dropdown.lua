local wezterm = require("wezterm")

-- 창 제목 강제 설정
wezterm.on("format-window-title", function()
	return "dropterm"
end)

return {
	window_background_opacity = 0.95,
	adjust_window_size_when_changing_font_size = false,
	font_size = 13.0,
	enable_tab_bar = false,
	initial_rows = 24,
	initial_cols = 100,
	window_decorations = "RESIZE",
	default_prog = { "/bin/zsh", "-l" },
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	window_frame = {
		border_left_width = "0.5cell",
		border_right_width = "0.5cell",
		border_bottom_height = "0.25cell",
		border_top_height = "0.25cell",
		border_left_color = "#444444",
		border_right_color = "#444444",
		border_top_color = "#444444",
		border_bottom_color = "#444444",
		active_titlebar_bg = "#111111",
		inactive_titlebar_bg = "#222222",
	},
	-- Optional: Drop-down feel
	font = wezterm.font_with_fallback({
		"JetBrainsMono Nerd Font",
		"Hack Nerd Font",
	}),
	launch_menu = {},
	color_scheme = "Catppuccin Mocha",
}
