local augroup = vim.api.nvim_create_augroup("dotfiles_autocmds", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank()
  end,
})
