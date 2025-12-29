local wezterm = require("wezterm")

-- Debug logging function
local function debug_log(message)
	wezterm.log_info("DEBUG: " .. tostring(message))
end

-- Function to get font size based on DPI
local function get_font_size_dpi(dpi)
	debug_log("get_font_size_dpi called with DPI: " .. tostring(dpi))
	local font_size
	if dpi >= 192 then
		font_size = 18
		debug_log("High DPI detected (>= 192), setting font size to " .. font_size)
	elseif dpi >= 144 then
		font_size = 16
		debug_log("Medium-high DPI detected (>= 144), setting font size to " .. font_size)
	elseif dpi >= 120 then
		font_size = 14
		debug_log("Medium DPI detected (>= 120), setting font size to " .. font_size)
	elseif dpi >= 96 then
		font_size = 13
		debug_log("Standard DPI detected (>= 96), setting font size to " .. font_size)
	else
		font_size = 12
		debug_log("Low DPI detected (< 96), setting font size to " .. font_size)
	end
	debug_log("Final font size: " .. font_size .. " for DPI: " .. tostring(dpi))
	return font_size
end

-- Function to get DPI of the monitor where the window is displayed
local function get_window_dpi(window)
	local dims = window:get_dimensions()
	local mid_x = (dims.x or 0) + (dims.pixel_width or 0) / 2
	local mid_y = (dims.y or 0) + (dims.pixel_height or 0) / 2
	local screens = wezterm.gui.screens()
	-- Log screens info
	if screens.main and screens.main.dpi then
		debug_log("screens.main.dpi = " .. tostring(screens.main.dpi))
	end
	local count = screens.all and #screens.all or 0
	debug_log("screens.all count = " .. tostring(count))
	for i, screen in ipairs(screens.all or {}) do
		debug_log(
			string.format(
				"screen[%d]: x=%d y=%d w=%d h=%d dpi=%d",
				i,
				screen.x,
				screen.y,
				screen.width,
				screen.height,
				screen.dpi
			)
		)
		if
			mid_x >= screen.x
			and mid_x < screen.x + screen.width
			and mid_y >= screen.y
			and mid_y < screen.y + screen.height
		then
			debug_log("Window midpoint on screen " .. i .. " with DPI: " .. tostring(screen.dpi))
			return screen.dpi
		end
	end
	-- Fallback to main
	if screens.main and screens.main.dpi then
		debug_log("Using main screen DPI: " .. tostring(screens.main.dpi))
		return screens.main.dpi
	end
	debug_log("No screens found, defaulting DPI to 96")
	return 96
end

-- WezTerm's window:get_dimensions().dpi gives the DPI of the monitor containing the window
-- so we can use it directly in our callback.

if wezterm.target_triple:find("darwin") then
	print("Mac")
elseif wezterm.target_triple:find("linux") then
	print("Linux")
elseif wezterm.target_triple:find("windows") then
	print("Windows")
end

wezterm.on("window-config-reloaded", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local dims = window:get_dimensions()
	debug_log(
		string.format(
			"Window dims: x=%d, y=%d, width=%d, height=%d, dpi=%d",
			dims.x or 0,
			dims.y or 0,
			dims.pixel_width or 0,
			dims.pixel_height or 0,
			dims.dpi or 0
		)
	)
	-- Use reported DPI, but if it's the default 96 on a large monitor, force a higher DPI
	local dpi = dims.dpi or 96
	if dpi == 96 and dims.pixel_width and dims.pixel_width >= 3000 then
		debug_log("Ultrawide detected by width (" .. dims.pixel_width .. "), forcing DPI to 144")
		dpi = 144
	end
	debug_log("Using DPI for font sizing: " .. tostring(dpi))
	local size = get_font_size_dpi(dpi)
	size = 14
	overrides.font_size = size
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
		"JetBrainsMono Nerd Font",
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
