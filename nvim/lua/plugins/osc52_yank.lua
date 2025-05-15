return {
  "ojroques/nvim-osc52",
  config = function()
    local osc52 = require("osc52")

    osc52.setup({
      max_length = 0,       -- 클립보드 길이 제한 (0은 무제한)
      silent = false,       -- true로 하면 메시지를 출력 안 함
      trim = false,         -- 복사한 문자열 앞뒤 공백 제거 여부
    })

    -- yank 할 때 자동으로 OSC52 사용하게 설정
    local function copy()
      if vim.v.event.operator == "y" and vim.v.event.regname == "" then
        osc52.copy_register("")
      end
    end

    vim.api.nvim_create_autocmd("TextYankPost", {
      callback = copy,
    })
  end
}
