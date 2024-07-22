
-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Function to remove extra trailing newlines
local function remove_extra_trailing_newlines()
        local line_count = vim.fn.line('$')
        while (line_count > 1) do
            local line_item = vim.fn.getline(line_count)
            -- print("line: ", line_count, "has: ", line_item)
            if (line_item:match("^$")) then
                local i = line_count - 1
                while vim.fn.getline(i):match("^$") do
                    vim.api.nvim_buf_set_lines(0, i - 1, i, false, {})
                    i = i - 1
                end
            end
            line_count = line_count-1
        end
    end

-- Create the autocmd using nvim_create_autocmd
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function(ev)
                    remove_extra_trailing_newlines()
               end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function (ev)
                    local filetype = vim.bo.filetype
                    if (filetype == 'cpp') then
                        vim.cmd('DiffFormat')
        end
    end
})

-- Remove trailing whitespace (https://vi.stackexchange.com/a/41388)
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function(ev)
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }
