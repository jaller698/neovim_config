-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require("lsp_signature").setup() end,
  -- },
  --
  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#ff4400" }) -- Use your desired color here
      -- customize the dashboard header
      local header_text = {
        [[          _____                    _____                    _____                    _____                    _____                    _____                    _____]],
        [[         /\    \                  /\    \                  /\    \                  /\    \                  /\    \                  /\    \                  /\    \]],
        [[        /::\    \                /::\____\                /::\    \                /::\____\                /::\____\                /::\    \                /::\____\]],
        [[       /::::\    \              /:::/    /               /::::\    \              /:::/    /               /:::/    /                \:::\    \              /::::|   |]],
        [[      /::::::\    \            /:::/    /               /::::::\    \            /:::/    /               /:::/    /                  \:::\    \            /:::::|   |]],
        [[     /:::/\:::\    \          /:::/    /               /:::/\:::\    \          /:::/    /               /:::/    /                    \:::\    \          /::::::|   |]],
        [[    /:::/  \:::\    \        /:::/____/               /:::/__\:::\    \        /:::/    /               /:::/____/                      \:::\    \        /:::/|::|   |]],
        [[   /:::/    \:::\    \      /::::\    \              /::::\   \:::\    \      /:::/    /                |::|    |                       /::::\    \      /:::/ |::|   |]],
        [[  /:::/    / \:::\    \    /::::::\    \   _____    /::::::\   \:::\    \    /:::/    /      _____      |::|    |     _____    ____    /::::::\    \    /:::/  |::|___|______]],
        [[ /:::/    /   \:::\    \  /:::/\:::\    \ /\    \  /:::/\:::\   \:::\    \  /:::/____/      /\    \     |::|    |    /\    \  /\   \  /:::/\:::\    \  /:::/   |::::::::\    \]],
        [[/:::/____/     \:::\____\/:::/  \:::\    /::\____\/:::/  \:::\   \:::\____\|:::|    /      /::\____\    |::|    |   /::\____\/::\   \/:::/  \:::\____\/:::/    |:::::::::\____\]],
        [[\:::\    \      \::/    /\::/    \:::\  /:::/    /\::/    \:::\  /:::/    /|:::|____\     /:::/    /    |::|    |  /:::/    /\:::\  /:::/    \::/    /\::/    / ~~~~~/:::/    /]],
        [[ \:::\    \      \/____/  \/____/ \:::\/:::/    /  \/____/ \:::\/:::/    /  \:::\    \   /:::/    /     |::|    | /:::/    /  \:::\/:::/    / \/____/  \/____/      /:::/    /]],
        [[  \:::\    \                       \::::::/    /            \::::::/    /    \:::\    \ /:::/    /      |::|____|/:::/    /    \::::::/    /                       /:::/    /]],
        [[   \:::\    \                       \::::/    /              \::::/    /      \:::\    /:::/    /       |:::::::::::/    /      \::::/____/                       /:::/    /]],
        [[    \:::\    \                      /:::/    /               /:::/    /        \:::\__/:::/    /        \::::::::::/____/        \:::\    \                      /:::/    /]],
        [[     \:::\    \                    /:::/    /               /:::/    /          \::::::::/    /          ~~~~~~~~~~               \:::\    \                    /:::/    /]],
        [[      \:::\    \                  /:::/    /               /:::/    /            \::::::/    /                                     \:::\    \                  /:::/    /]],
        [[       \:::\____\                /:::/    /               /:::/    /              \::::/    /                                       \:::\____\                /:::/    /]],
        [[        \::/    /                \::/    /                \::/    /                \::/____/                                         \::/    /                \::/    /]],
        [[         \/____/                  \/____/                  \/____/                  ~~                                                \/____/                  \/____/]],
      }

      local stats = require("lazy").stats()
      local total_plugins = stats.count
      local datetime = tonumber(os.date "%H")
      local greeting = function()
        -- Determine the appropriate greeting based on the hour
        local mesg
        -- Get UserName
        local username = os.getenv "USERNAME"
        if datetime >= 0 and datetime < 6 then
          mesg = "Dreaming..󰒲 󰒲 "
        elseif datetime >= 6 and datetime < 12 then
          mesg = "🌅 Hi " .. username .. ", Good Morning ☀️"
        elseif datetime >= 12 and datetime < 18 then
          mesg = "🌞 Hi " .. username .. ", Good Afternoon ☕️"
        elseif datetime >= 18 and datetime < 21 then
          mesg = "🌆 Hi " .. username .. ", Good Evening 🌙"
        else
          mesg = "Hi " .. username .. ", it's getting late, get some sleep 😴"
        end
        return mesg
      end
      local function footer()
        local footer_datetime = os.date "  %m-%d-%Y   %H:%M:%S"
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        local value = footer_datetime .. "   Plugins " .. total_plugins .. nvim_version_info
        return value
      end
      -- Directly assign the list of strings to the header
      opts.section.header.val = header_text
      opts.section.footer.val = footer()
      -- Apply the highlight group to the header using the hl attribute
      opts.section.header.opts = {
        hl = "AlphaHeader",
        position = "center",
      }
      opts.section.footer.opts = {
        position = "center",
      }
      local alpha = require "alpha"
      alpha.setup(opts.config)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        -- Your telescope configuration here
      }
    end,
  },

  -- You can disable default plugins as follows:
  -- { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  -- {
  --   "L3MON4D3/LuaSnip",
  --   config = function(plugin, opts)
  --     require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom luasnip configuration such as filetype extend or custom snippets
  --     local luasnip = require "luasnip"
  --     luasnip.filetype_extend("javascript", { "javascriptreact" })
  --   end,
  -- },
  --
  -- {
  --   "windwp/nvim-autopairs",
  --   config = function(plugin, opts)
  --     require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom autopairs configuration such as custom rules
  --     local npairs = require "nvim-autopairs"
  --     local Rule = require "nvim-autopairs.rule"
  --     local cond = require "nvim-autopairs.conds"
  --     npairs.add_rules(
  --       {
  --         Rule("$", "$", { "tex", "latex" })
  --           -- don't add a pair if the next character is %
  --           :with_pair(cond.not_after_regex "%%")
  --           -- don't add a pair if  the previous character is xxx
  --           :with_pair(
  --             cond.not_before_regex("xxx", 3)
  --           )
  --           -- don't move right when repeat character
  --           :with_move(cond.none())
  --           -- don't delete if the next character is xx
  --           :with_del(cond.not_after_regex "xx")
  --           -- disable adding a newline when you press <cr>
  --           :with_cr(cond.none()),
  --       },
  --       -- disable for .vim files, but it work for another filetypes
  --       Rule("a", "a", "-vim")
  --     )
  --   end,
  -- },
}
