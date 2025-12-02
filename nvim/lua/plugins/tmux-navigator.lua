return {
	"christoomey/vim-tmux-navigator",
	lazy = false, -- 항상 로드되도록 설정
	config = function()
		-- 기본 매핑을 비활성화하고 직접 지정
		vim.g.tmux_navigator_no_mappings = 1

		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", opts)
		vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", opts)
		vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", opts)
		vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", opts)
		vim.keymap.set("n", "<C-\\>", ":TmuxNavigatePrevious<CR>", opts)
	end,
}
