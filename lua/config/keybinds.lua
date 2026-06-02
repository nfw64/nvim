local opts = {
	noremap = true, -- non-recursive
	silent = true, -- do not show message
}
vim.g.mapleader = " "

vim.keymap.set("n", "<C-s>", vim.cmd.w)
vim.keymap.set("i", "<C-s>", vim.cmd.w)
vim.keymap.set("v", "<C-s>", vim.cmd.w)
vim.keymap.set("n", "<C-q>", vim.cmd.q)

vim.keymap.set("n", "<leader>Rol", function()
	vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
	print("Configuration reloaded!")
end, { desc = "Reload Neovim Config" })

-----------------
-- Insert mode --
-----------------

vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move left one character" })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Jump to end of line" })

-----------------
-- Normal mode --
-----------------

vim.keymap.set({ "n", "v", "o" }, "gh", "^", { desc = "Go to start of line" })
vim.keymap.set({ "n", "v", "o" }, "gl", "$", { desc = "Go to end of line" })
vim.keymap.set("n", "<leader>cd", "<cmd>Oil<CR>", { desc = "Oil" })

vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)

-- Global table to store closed buffers with timestamps
_G.deleted_buffers_history = _G.deleted_buffers_history or {}

-- Track closed buffers automatically
vim.api.nvim_create_autocmd("BufDelete", {
	group = vim.api.nvim_create_augroup("BufferUndoTracker", { clear = true }),
	callback = function(args)
		local buf_name = vim.api.nvim_buf_get_name(args.buf)
		local buf_type = vim.bo[args.buf].buftype

		if buf_name ~= "" and buf_type == "" then
			table.insert(_G.deleted_buffers_history, {
				path = buf_name,
				time = os.clock(),
			})
			if #_G.deleted_buffers_history > 30 then
				table.remove(_G.deleted_buffers_history, 1)
			end
		end
	end,
})

-- Map the <leader>bu undo button globally
vim.keymap.set("n", "<leader>bu", function()
	if #_G.deleted_buffers_history == 0 then
		print("No closed buffers to undo!")
		return
	end

	local last_item = table.remove(_G.deleted_buffers_history)
	vim.cmd("badd " .. vim.fn.fnameescape(last_item.path))
	local count = 1

	while #_G.deleted_buffers_history > 0 do
		local next_item = _G.deleted_buffers_history[#_G.deleted_buffers_history]
		if math.abs(last_item.time - next_item.time) < 0.05 then
			table.remove(_G.deleted_buffers_history)
			vim.cmd("badd " .. vim.fn.fnameescape(next_item.path))
			count = count + 1
		else
			break
		end
	end

	print("Restored " .. count .. " buffer(s)!")
end, { desc = "Undo last buffer closure" })
