local function copy_to_windows_clipboard(text)
  local handle = io.popen('xclip -selection clipboard', 'w')
  if handle then
    handle:write(text)
    handle:close()
  end
end

vim.api.nvim_create_augroup('WSLYank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'WSLYank',
  pattern = '*',
  callback = function()
    if not vim.v.event.regcontents or #vim.v.event.regcontents == 0 then
      return
    end
    local reg_contents = table.concat(vim.v.event.regcontents, "\n")
    copy_to_windows_clipboard(reg_contents)
  end,
})

