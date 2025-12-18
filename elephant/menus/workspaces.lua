--
-- Workspace switcher menu for Elephant/Walker (Hyprland)
--
-- Requirements:
-- - Show only non-empty workspaces
-- - Each entry starts with workspace id
-- - Then list window information in that workspace
-- - Selecting an entry focuses that workspace
--

Name = "workspaces"
NamePretty = "Workspaces"
Icon = "view-grid"
Cache = false
SearchName = true
Description = "Switch to a non-empty workspace"
Action = "hyprctl dispatch workspace %VALUE%"

local function _read_all(handle)
	if not handle then
		return nil
	end
	local data = handle:read("*a")
	handle:close()
	return data
end

local function _shell_escape_single(s)
	-- safest for embedding a string in single quotes
	return (tostring(s or ""):gsub("'", "'\\''"))
end

local function _trim(s)
	s = tostring(s or "")
	s = s:gsub("^%s+", "")
	s = s:gsub("%s+$", "")
	return s
end

local function _alt_matches_value(alt, value)
	alt = tostring(alt or "")
	value = tostring(value or "")
	if alt == "" or value == "" then
		return false
	end

	-- Regex-ish patterns used in Waybar config, handled best-effort.
	-- 1) ^Exact$
	local exact = alt:match("^%^(.*)%$$")
	if exact ~= nil then
		return value == exact
	end

	-- 2) .*contains.*
	if alt:sub(1, 2) == ".*" and alt:sub(-2) == ".*" and #alt >= 4 then
		local needle = alt:sub(3, -3)
		needle = needle:gsub("\\", "")
		if needle ~= "" then
			return value:lower():find(needle:lower(), 1, true) ~= nil
		end
	end

	-- 3) Plain exact (case-insensitive)
	local has_meta = alt:find("[%[%]%^%$%*%?%+%(%)]") ~= nil
	if not has_meta then
		return value:lower() == alt:lower()
	end

	-- 4) Character classes / simple lua-pattern compatible pieces
	local ok, res = pcall(function()
		return value:match("^" .. alt .. "$") ~= nil
	end)
	return ok and res or false
end

local function _text_icon_from_window(class, title)
	local cls = _trim(class)
	local ttl = _trim(title)

	-- Embedded from ~/.config/waybar/ModulesWorkspaces (window-rewrite)
	-- Note: Matching is best-effort (Lua patterns), title rules first.
	local default_icon = ""
	local title_rules = {
		{ alts = { ".*amazon.*" }, icon = "" },
		{ alts = { ".*reddit.*" }, icon = "" },
		{ alts = { ".*gmail.*" }, icon = "󰊫" },
		{ alts = { ".*Signal.*" }, icon = "󰍩" },
		{ alts = { ".*whatsapp.*" }, icon = "" },
		{ alts = { ".*zapzap.*" }, icon = "" },
		{ alts = { ".*messenger.*" }, icon = "" },
		{ alts = { ".*facebook.*" }, icon = "" },
		{ alts = { ".*Discord.*" }, icon = "" },
		{ alts = { ".*ChatGPT.*" }, icon = "󰚩" },
		{ alts = { ".*deepseek.*" }, icon = "󰚩" },
		{ alts = { ".*qwen.*" }, icon = "󰚩" },
		{ alts = { ".*Picture%-in%-Picture.*" }, icon = "" },
		{ alts = { ".*youtube.*" }, icon = "" },
		{ alts = { ".*Kdenlive.*" }, icon = "🎬" },
		{ alts = { ".*cmus.*" }, icon = "" },
		{ alts = { ".*github.*" }, icon = "" },
		{ alts = { ".*nvim ~.*" }, icon = "" },
		{ alts = { ".*vim.*" }, icon = "" },
		{ alts = { ".*nvim.*" }, icon = "" },
		{ alts = { ".*figma.*" }, icon = "" },
		{ alts = { ".*jira.*" }, icon = "" },
		{ alts = { "^Bazaar$" }, icon = "" },
		{ alts = { "^satty$" }, icon = "" },
		{ alts = { ".*BoxBuddy.*" }, icon = "" },
		{ alts = { "Hyprland Keybinds" }, icon = "" },
		{ alts = { "Niri Keybinds" }, icon = "" },
		{ alts = { "BSPWM Keybinds" }, icon = "" },
		{ alts = { "DWM Keybinds" }, icon = "" },
		{ alts = { "Emacs Leader Keybinds" }, icon = "" },
		{ alts = { "Kitty Configuration" }, icon = "" },
		{ alts = { "WezTerm Configuration" }, icon = "" },
		{ alts = { "Yazi Configuration" }, icon = "" },
		{ alts = { "Cheatsheets Viewer" }, icon = "" },
		{ alts = { "Documentation Viewer" }, icon = "" },
		{ alts = { "^Wallpapers$" }, icon = "" },
		{ alts = { "^Video Wallpapers$" }, icon = "" },
		{ alts = { "^qs%-wlogout$" }, icon = "" },
		{ alts = { "virtualbox" }, icon = "💽" },
		{ alts = { "tor browser" }, icon = "" },
		{ alts = { "^Bazaar$" }, icon = "" },
		{ alts = { "^satty$" }, icon = "" },
	}

	local class_rules = {
		{ alts = { "firefox", "org.mozilla.firefox", "librewolf", "floorp", "mercury%-browser", "[Cc]achy%-browser" }, icon = "" },
		{ alts = { "zen" }, icon = "󰰷" },
		{ alts = { "waterfox", "waterfox%-bin" }, icon = "" },
		{ alts = { "microsoft%-edge" }, icon = "" },
		{ alts = { "Chromium", "Thorium", "[Cc]hrome" }, icon = "" },
		{ alts = { "brave%-browser" }, icon = "🦁" },
		{ alts = { "firefox%-developer%-edition" }, icon = "🦊" },

		{ alts = { "kitty", "konsole", "[Aa]lacritty" }, icon = "" },
		{ alts = { "kitty%-dropterm" }, icon = "" },
		{ alts = { "com.mitchellh.ghostty", "com%.mitchellh%.ghostty", "ghostty" }, icon = "" },
		{ alts = { "org.wezfurlong.wezterm", "org%.wezfurlong%.wezterm", "wezterm" }, icon = "" },
		{ alts = { "Warp", "warp", "dev%.warp%.Warp", "warp%-terminal" }, icon = "󰰭" },

		{ alts = { "[Tt]hunderbird", "[Tt]hunderbird%-esr" }, icon = "" },
		{ alts = { "eu%.betterbird%.Betterbird" }, icon = "" },

		{ alts = { "[Tt]elegram%-desktop", "org%.telegram%.desktop", "io%.github%.tdesktop_x64%.TDesktop" }, icon = "" },
		{ alts = { "discord", "discord%-canary", "[Ww]ebcord", "[Vv]esktop", "com%.discordapp%.Discord", "dev%.vencord%.Vesktop" }, icon = "" },
		{ alts = { "[Ss]ignal", "signal%-desktop", "org%.signal%.Signal" }, icon = "󰍩" },

		{ alts = { "subl" }, icon = "󰅳" },
		{ alts = { "slack" }, icon = "" },

		{ alts = { "mpv" }, icon = "" },
		{ alts = { "celluloid", "Zoom" }, icon = "" },
		{ alts = { "Cider" }, icon = "󰎆" },
		{ alts = { "vlc" }, icon = "󰕼" },
		{ alts = { "[Kk]denlive", "org%.kde%.kdenlive" }, icon = "🎬" },
		{ alts = { "[Ss]potify" }, icon = "" },
		{ alts = { "Plex" }, icon = "󰚺" },

		{ alts = { "virt%-manager", "%.virt%-manager%-wrapped", "remote%-viewer", "virt%-viewer", "virt%-viewer" }, icon = "" },
		{ alts = { "virtualbox manager" }, icon = "💽" },
		{ alts = { "remmina", "org%.remmina%.Remmina" }, icon = "🖥️" },

		{ alts = { "VSCode", "code", "code%-url%-handler", "code%-oss", "codium", "codium%-url%-handler", "VSCodium" }, icon = "󰨞" },
		{ alts = { "dev%.zed%.Zed" }, icon = "󰵁" },
		{ alts = { "codeblocks" }, icon = "󰅩" },
		{ alts = { "mousepad" }, icon = "" },
		{ alts = { "libreoffice%-writer" }, icon = "" },
		{ alts = { "libreoffice%-startcenter" }, icon = "󰏆" },
		{ alts = { "libreoffice%-calc" }, icon = "" },
		{ alts = { "jetbrains%-idea" }, icon = "" },
		{ alts = { "obs", "com%.obsproject%.Studio" }, icon = "" },
		{ alts = { "polkit%-gnome%-authentication%-agent%-1" }, icon = "󰒃" },
		{ alts = { "nwg%-look" }, icon = "" },
		{ alts = { "nwg%-displays" }, icon = "" },
		{ alts = { "[Pp]avucontrol", "org%.pulseaudio%.pavucontrol" }, icon = "󱡫" },
		{ alts = { "steam" }, icon = "" },
		{ alts = { "thunar", "nemo" }, icon = "󰝰" },
		{ alts = { "Gparted" }, icon = "" },
		{ alts = { "gimp" }, icon = "" },
		{ alts = { "emulator" }, icon = "📱" },
		{ alts = { "android%-studio" }, icon = "" },
		{ alts = { "org%.pipewire%.Helvum" }, icon = "󰓃" },
		{ alts = { "localsend" }, icon = "" },
		{ alts = { "PrusaSlicer", "UltiMaker%-Cura", "OrcaSlicer" }, icon = "󰹛" },
		{ alts = { "io%.github%.kolunmi%.Bazaar" }, icon = "" },
		{ alts = { "com%.gabm%.satty" }, icon = "" },
		{ alts = { "[Bb]ox[Bb]uddy", "io%.github%.dvlv%.boxbuddy", "io%.github%.dvlv%.BoxBuddy" }, icon = "" },
	}

	for _, rule in ipairs(title_rules) do
		for _, alt in ipairs(rule.alts) do
			if _alt_matches_value(alt, ttl) then
				return rule.icon ~= "" and rule.icon or default_icon
			end
		end
	end
	for _, rule in ipairs(class_rules) do
		for _, alt in ipairs(rule.alts) do
			if _alt_matches_value(alt, cls) then
				return rule.icon ~= "" and rule.icon or default_icon
			end
		end
	end

	return default_icon
end

local function _get_workspace_lines()
	-- Use jq to parse hyprctl JSON (avoid python dependency)
	local jq_filter = [[def cls:(.class // .initialClass // "")|tostring; def ttl:(.title // .initialTitle // "")|tostring; ( . | map(select((.workspace.id // 0) >= 0)) | map(select(((.workspace.name // "") | startswith("special:")) | not)) | sort_by(.workspace.id, (cls), (ttl)) | .[] | ((.workspace.id|tostring) as $id | (cls) as $c | (ttl) as $t | "\($id)\t\($c)\t\($t)" ) )]]

	-- Note: keep jq filter single-quote safe (no single quotes inside)
	local cmd = "hyprctl -j clients 2>/dev/null | jq -r '" .. _shell_escape_single(jq_filter) .. "' 2>/dev/null"
	local handle = io.popen(cmd)
	return handle
end

function GetEntries()
	local entries = {}

	local handle = _get_workspace_lines()
	if not handle then
		return entries
	end

	local workspace_sub_lines = {}
	local workspace_ids = {}
	local seen = {}
	for line in handle:lines() do
		local id, class, title = line:match("^(.-)\t(.-)\t(.*)$")
		if id then
			id = tostring(id)
			class = tostring(class or "")
			title = tostring(title or "")
			if not workspace_sub_lines[id] then
				workspace_sub_lines[id] = {}
			end
			if not seen[id] then
				seen[id] = true
				table.insert(workspace_ids, id)
			end

			local icon_text = _text_icon_from_window(class, title)
			local title_text = title
			if title_text == "" then
				title_text = class
			end
			if title_text == "" then
				title_text = "(untitled)"
			end
			title_text = title_text:gsub("[%c]", " ")

			table.insert(workspace_sub_lines[id], icon_text .. " " .. title_text)
		end
	end

	handle:close()

	table.sort(workspace_ids, function(a, b)
		return tonumber(a) < tonumber(b)
	end)

	for _, id in ipairs(workspace_ids) do
		local sublines = workspace_sub_lines[id] or {}
		if #sublines > 0 then
			local subtext = table.concat(sublines, "\n")
			table.insert(entries, {
				Text = id,
				Subtext = subtext,
				Value = id,
				Icon = "",
				Actions = {
					focus = "hyprctl dispatch workspace " .. id,
				},
			})
		end
	end

	return entries
end
