-- Various auto-formating configuartions, including a custom formatter to only format changed lines (useful in larger repos)
require("conform").setup({
  formatters_by_ft = {
    cpp = {"clang-format"},
  }
})

require('lspconfig').clangd.setup({
  name='clangd',
  cmd = {
    'clangd',
    '--background-index',
    '--log=verbose',
    '--all-scopes-completion',
    '--limit-references=0',
    '--header-insertion=iwyu'
  },
})

vim.api.nvim_create_user_command('DiffFormat', function()
  local ignore_filetypes = { "lua" }
  if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
    vim.notify("range formatting for " .. vim.bo.filetype .. " not working properly.")
    return
  end

  local hunks = require("gitsigns").get_hunks()
  if hunks == nil then
    return
  end

  local format = require("conform").format

  local function format_range()
    if next(hunks) == nil then
      vim.cmd('noautocmd w')
      vim.notify("done formatting git hunks", "info", { title = "formatting" })
      return
    end
    local hunk = nil
    while next(hunks) ~= nil and (hunk == nil or hunk.type == "delete") do
      hunk = table.remove(hunks)
    end

    if hunk ~= nil and hunk.type ~= "delete" then
      local start = hunk.added.start
      local last = start + hunk.added.count
      -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
      local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
      local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
      format({ range = range, async = true, lsp_fallback = true }, function()
        vim.defer_fn(function()
          format_range()
        end, 1)
      end)
    end
  end

  format_range()
end, { desc = 'Format changed lines' })

-- Setup the function to be used when saving
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.cpp',
    callback = function (ev)
                    vim.cmd('DiffFormat')
               end
})
