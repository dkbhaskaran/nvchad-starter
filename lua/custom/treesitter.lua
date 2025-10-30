-- lua/custom/treesitter.lua
local ok, ts = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

ts.setup {
  highlight = { enable = true },
  indent = { enable = true },
  ensure_installed = {}, -- no pinning; avoids future conflicts/CI noise
  auto_install = false,
}
