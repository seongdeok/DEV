return {
	-- CMake tools integration
	"Civitasv/cmake-tools.nvim",
	ft = { "cpp", "c", "cmake" },
	config = function()
		require("cmake-tools").setup({
			cmake_command = "cmake",
			cmake_build_directory = "build",
			cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
			cmake_build_options = {},
			cmake_console_size = 10,
			cmake_show_console = "always",
		})

		-- CMake keymaps
		vim.keymap.set("n", "<leader>cg", "<cmd>CMakeGenerate<CR>", { desc = "CMake Generate" })
		vim.keymap.set("n", "<leader>cb", "<cmd>CMakeBuild<CR>", { desc = "CMake Build" })
		vim.keymap.set("n", "<leader>cr", "<cmd>CMakeRun<CR>", { desc = "CMake Run" })
		vim.keymap.set("n", "<leader>cc", "<cmd>CMakeClean<CR>", { desc = "CMake Clean" })
		vim.keymap.set("n", "<leader>ct", "<cmd>CMakeSelectBuildType<CR>", { desc = "CMake Build Type" })
	end,
}
