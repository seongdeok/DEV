Name = "images"
NamePretty = "Image Browser"
Icon = "image-x-generic"
Cache = false
Action = "xdg-open %VALUE%"
Description = "Browse images from folder"
SearchName = true

function GetEntries()
	local entries = {}
	--local image_dir = os.getenv("HOME") .. "/Downloads"

	-- Change the folder path to your desired directory
	local image_dir = os.getenv("HOME") .. "/Downloads/walls-main/calm"

	local handle = io.popen(
		"find '"
			.. image_dir
			.. "' -maxdepth 1 -type f \\( "
			.. "-name '*.jpg' -o -name '*.jpeg' -o "
			.. "-name '*.png' -o -name '*.gif' -o "
			.. "-name '*.bmp' -o -name '*.webp' -o "
			.. "-name '*.svg' \\) 2>/dev/null | sort"
	)

	if handle then
		for line in handle:lines() do
			local filename = line:match("([^/]+)$")
			if filename then
				table.insert(entries, {
					Text = filename,
					Subtext = line,
					Value = line,
					Icon = line, -- Use the image itself as the icon
					Preview = line,
					PreviewType = "file",
					Actions = {
						open = "xdg-open '" .. line .. "'",
						copy_path = "wl-copy '" .. line .. "'",
						copy_file = "wl-copy < '" .. line .. "'",
					},
				})
			end
		end
		handle:close()
	end

	return entries
end
