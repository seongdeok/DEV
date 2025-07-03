return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			auto_session_enabled = true,
			auto_save_enabled = true,
			auto_restore_enabled = true,
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			session_lens = {
				buftypes_to_ignore = {},
				path_display = { "shorten" },
				load_on_setup = true,
				theme_conf = {
					border = true,
					width = 0.8,
					height = 0.8,
					prompt_title = "Sessions",
					preview_title = "Session Preview",
				},
				vim.keymap.set("n", "<leader>ls", require("auto-session.session-lens").search_session, {
					desc = "Search Sessions",
					noremap = true,
				}),
			},
		})
	end,
}
