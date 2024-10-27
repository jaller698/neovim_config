-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- switch buffer with æ and ø, on Danish keyboards
vim.cmd [[ 
  nnoremap <silent> æ :bp<CR>
  nnoremap <silent> ø :bn<CR>
]]
