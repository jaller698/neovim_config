local M = {}

-- Configuration (can be customized if needed)
local config = {
  api_url = "http://localhost:11435/api/generate",
}

-- Function to make a request to the local Code Llama API
local function request_completion(context)
  -- vim.api.nvim_echo()
  local curl = "curl -s -X POST " .. config.api_url .. " -H 'Content-Type: application/json' "
  local model = "codellama:code"
  local data = "--data '"
    .. vim.fn.json_encode {
      model = model,
      prompt = context,
      suffix = "   return result",
      stream = false,
      options = { temperature = 0 },
    }
    .. "'"
  vim.notify(curl .. data)
  local handle = io.popen(curl .. data)
  local result = handle:read "*a"
  handle:close()
  vim.notify(result)
  -- Parse the result as JSON
  if result and result ~= "" then
    local json_response = vim.fn.json_decode(result)
    suggestion = json_response and json_response.response or ""

    -- Show the suggestion as virtual text
    if suggestion and suggestion ~= "" then
      local bufnr = vim.api.nvim_get_current_buf()
      local linenr = vim.fn.line "." - 1
      vim.api.nvim_buf_set_extmark(bufnr, vim.api.nvim_create_namespace "CodeLlama", linenr, -1, {
        virt_text = { { suggestion, "Comment" } }, -- Show the suggestion in a 'Comment' style
        virt_text_pos = "eol",
      })
    end
  else
    vim.notify "No response from Code Llama"
  end
end

local function get_current_line()
  local current_line = vim.api.nvim_buf_get_lines(0, vim.fn.line "." - 1, vim.fn.line ".", false)[1]
  return current_line or ""
end

-- Function to insert the suggestion on Tab
local function insert_suggestion()
  if suggestion and suggestion ~= "" then
    -- Insert the suggestion into the current line
    local current_line = get_current_line()
    vim.api.nvim_set_current_line(current_line .. suggestion)
    suggestion = nil -- Clear the suggestion after inserting
  end
end

-- Create a Neovim command :CodeLlama that triggers completion
vim.api.nvim_create_user_command("CodeLlama", function()
  local context = get_current_line()
  request_completion(context)
end, {})
vim.api.nvim_set_keymap("i", "<Tab>", 'v:lua.require("llama").insert_suggestion()', { expr = true, noremap = true })
return M
