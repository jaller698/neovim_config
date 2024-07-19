-- Function to update the Neovim configuration repository
local function update_config()
    -- Path to your local git repository
    local repo_path = vim.fn.stdpath "config"  -- Assuming your config repo is the Neovim config directory

    -- Command to pull the latest changes
    local pull_command = { "git", "-C", repo_path, "pull" }

    -- Execute the command
    local result = vim.fn.systemlist(pull_command)

    -- Print the result of the git pull command
    if vim.v.shell_error == 0 then
        print("Configuration updated successfully!")
    else
        print("Failed to update configuration:")
        for _, line in ipairs(result) do
            print(line)
        end
    end
end

update_config()
-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"
