return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
					"pylint",
					"eslint_d",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			---------------------------------------------------------------------------
			-- 1. LSP 붙을 때 공통으로 쓸 키맵
			---------------------------------------------------------------------------
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local opts = { buffer = bufnr, silent = true }

					-- 기본 LSP
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					-- 진단 이동
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				end,
			})

			---------------------------------------------------------------------------
			-- 2. 모든 서버에 공통으로 적용할 옵션 (원하면 추후 capabilities 등 넣기)
			---------------------------------------------------------------------------
			vim.lsp.config("*", {
				-- 공통 설정 넣고 싶으면 여기에
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			---------------------------------------------------------------------------
			-- 3. 언어별 서버 설정
			---------------------------------------------------------------------------

			-- Lua (네오빔 설정용)
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			-- C / C++
			vim.lsp.config("clangd", {
				cmd = { "clangd", "--background-index" },
				-- filetypes, root_markers 등은 nvim-lspconfig 기본값을 그대로 사용해도 됨
			})

			-- Python
			vim.lsp.config("pyright", {
				-- 특별히 커스텀 없으면 비워둬도 됨
				-- settings = { python = { analysis = { typeCheckingMode = "basic" } } },
			})

			-- Rust
			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						check = {
							command = "clippy",
						},
					},
				},
			})

			---------------------------------------------------------------------------
			-- 4. 서버 활성화
			---------------------------------------------------------------------------
			for _, name in ipairs({ "lua_ls", "clangd", "pyright", "rust_analyzer" }) do
				vim.lsp.enable(name)
			end
		end,
	},
}
