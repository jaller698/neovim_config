
local function enable_transparency()
        -- Set transparent background
  require("transparent").setup()
end

-- Run the transparenc toggle
vim.notify "loading alacritty specific config"
enable_transparency()
