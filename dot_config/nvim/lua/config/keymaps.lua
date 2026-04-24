local map = vim.keymap.set

map("n", "<leader>fn", function()
  vim.cmd("enew")
end, { desc = "New buffer" })


