return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					hidden = true,
					no_ignore = true,
					follow = true,
					find_command = {
						"fd",
						"-H",
						"-I",
						"-L",
						"--type",
						"f",
						"--exclude",
						".git",
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"-L",
						"-uuu",
						"--glob",
						"!.git/*",
					},
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-h>"] = actions.cycle_history_prev,
							["<C-l>"] = actions.cycle_history_next,
						},
						n = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-h>"] = actions.cycle_history_prev,
							["<C-l>"] = actions.cycle_history_next,
						},
					},
				},
			})
			-- vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
			-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<C-p>", function()
				builtin.find_files({
					cwd = vim.loop.cwd(),
					hidden = true,
					no_ignore = true,
					follow = true,
				})
			end, { desc = "Telescope find files" })

			vim.keymap.set("n", "<leader>fg", function()
				builtin.live_grep({
					cwd = vim.loop.cwd(),
					hidden = true,
					no_ignore = true,
					follow = true,
				})
			end, { desc = "Telescope live grep" })

			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
