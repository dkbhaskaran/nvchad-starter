-- lua/custom/conform.lua
local ok, conform = pcall(require, "conform")
if not ok then
  return
end

conform.setup {
  notify_on_error = false, -- stay quiet if tool is missing
  format_on_save = function(bufnr)
    -- Only if server/formatter exists; else skip silently.
    return { timeout_ms = 2000, lsp_fallback = true }
  end,
  -- Configure only tools you actually want; missing ones are fine
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format", "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "jq", "prettier" },
    yaml = { "yamlfmt" },
    markdown = { "mdformat" },
    cpp = { "clang_format" },
  },
}
