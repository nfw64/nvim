return {
	{
		"saghen/blink.cmp",
		opts = {
			keymap = {
				preset = "none", -- Disable defaults so they do not conflict

				-- Accept suggestion with Ctrl-n
				["<C-n>"] = { "accept", "fallback" },
				["<CR>"] = { "accept", "fallback" },

				-- Navigate suggestions with Ctrl-j and Ctrl-k
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
			},
		},
	},
}
