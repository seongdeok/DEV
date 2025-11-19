return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"jay-babu/mason-nvim-dap.nvim",
			"nvim-neotest/nvim-nio", -- 필수 의존성 추가
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb" },
				automatic_installation = true,
			})

			for _, config in ipairs(dap.configurations.rust or {}) do
				config.stopOnEntry = true
			end

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dap.set_breakpoint("main")
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dap.listeners.before.launch["break"] = function()
				dap.set_breakpoint("main")
			end
			-- main 함수 자동 브레이크
			--dap.listeners.before.event_initialized["auto_break_main"] = function()
			--	dap.set_breakpoint("main")
			--	dap.continue()
			--end

			-- 종료 시 일시정지
			--dap.listeners.before.event_terminated["pause_on_exit"] = function()
			--	print("프로그램이 종료되었습니다. 콘솔 출력을 확인하세요.")
			--	vim.fn.input("Press <Enter> to close DAP session...")
			--end

			-- DAP keymaps
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dc", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Conditional Breakpoint" })
			vim.keymap.set("n", "<leader>dr", dapui.toggle, { desc = "Toggle DAP UI" })
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		ft = { "rust" },
	},
}
