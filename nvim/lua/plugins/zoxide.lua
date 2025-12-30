return {
	"jvgrootveld/telescope-zoxide",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("telescope").setup({
			extensions = {
				zoxide = {
					mappings = {
						default = {
							after_action = function(selection)
								require("telescope.builtin").find_files({
									cwd = selection.path,
								})
							end,
						},
					},
				},
			},
		})
		-- Telescope가 이 확장을 사용하도록 로드합니다.
		require("telescope").load_extension("zoxide")
		-- <leader>cd를 누르면 zoxide 검색창이 뜹니다.
		vim.keymap.set("n", "<leader>cd", require("telescope").extensions.zoxide.list)
	end,
}
