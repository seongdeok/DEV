return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {},
					never_show = {},
				},
				follow_current_file = {
					enable = true,
				},
				use_libuv_file_watcher = true,
			},
		})

		vim.keymap.set("n", "<C-e>", ":Neotree toggle<CR>", {})
	end,
}
