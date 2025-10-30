-- lua/custom/lsp.lua
local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
if not ok_lspconfig then return end

-- Always set up mason first (safe if already set)
local ok_mason, mason = pcall(require, "mason")
if ok_mason then mason.setup({}) end

local ok_mlsp, mlsp = pcall(require, "mason-lspconfig")

local servers = {
  "lua_ls", "pyright", "tsserver", "html", "cssls", "jsonls",
  "bashls", "clangd", "cmake", "yamlls", "marksman",
}

-- Capabilities (optional cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local function on_attach(_, bufnr)
  local map = function(m, lhs, rhs, desc)
    vim.keymap.set(m, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
  map("n", "gr", vim.lsp.buf.references, "LSP: References")
  map("n", "K",  vim.lsp.buf.hover, "LSP: Hover")
end

local function setup_server(name)
  if not (lspconfig[name] and lspconfig[name].setup) then return end
  local ok = pcall(lspconfig[name].setup, {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = (name == "lua_ls") and {
      Lua = { diagnostics = { globals = { "vim" } } },
    } or nil,
  })
  if not ok then
    vim.schedule(function()
      vim.notify(("LSP: skipping %s (not installed)"):format(name), vim.log.levels.INFO)
    end)
  end
end

if ok_mlsp then
  -- Support BOTH old and new mason-lspconfig APIs
  local handler = function(server_name) setup_server(server_name) end

  if type(mlsp.setup_handlers) == "function" then
    -- Older API: separate setup_handlers()
    mlsp.setup({ ensure_installed = {}, automatic_installation = false })
    mlsp.setup_handlers({ handler })
  else
    -- Newer API: handlers inside setup()
    mlsp.setup({
      ensure_installed = {},
      automatic_installation = false,
      handlers = { handler },
    })
  end
else
  -- mason-lspconfig missing: just try to set up known servers directly
  for _, s in ipairs(servers) do setup_server(s) end
end

vim.diagnostic.config({
  underline = true,
  virtual_text = { spacing = 2, prefix = "●" },
  severity_sort = true,
  update_in_insert = false,
})

