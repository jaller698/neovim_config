local function update_config()
  local last_update_file = vim.fn.stdpath "state" .. "/last_update_time" -- File to store last update time
  local current_time = os.time()
  local one_day_in_seconds = 24 * 60 * 60

  -- Check if the last update file exists and read the time
  local last_update_time = nil
  if vim.fn.filereadable(last_update_file) == 1 then
    local file = io.open(last_update_file, "r")
    if file then
      last_update_time = tonumber(file:read "*all")
      file:close()
    end
  end

  -- If the last update was more than a day ago, run the update
  if not last_update_time or (current_time - last_update_time) > one_day_in_seconds then
    -- Path to your local git repository
    local repo_path = vim.fn.stdpath "config" -- Assuming your config repo is the Neovim config directory

    -- Command to pull the latest changes
    local pull_command = { "git", "-C", repo_path, "pull" }

    -- Execute the command
    local result = vim.fn.systemlist(pull_command)

    -- Use vim.notify for notification
    if vim.v.shell_error == 0 then
      vim.notify "Configuration updated successfully!"

      -- Save the current time to the file as the last update time
      local file = io.open(last_update_file, "w")
      if file then
        file:write(tostring(current_time))
        file:close()
      end
    else
      vim.notify("Failed to update configuration!", vim.log.levels.ERROR)
      -- Optional: Show detailed error messages
      for _, line in ipairs(result) do
        vim.notify(line, vim.log.levels.ERROR)
      end
    end
  else
    vim.notify "Configuration already updated today."
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
end
require "lazy_setup"
require "polish"
if vim.g.neovide then require "neovide" end
vim.notify (vim.env.TERM)
if vim.env.TERM == "alacritty" then require "alacritty" end
