-- lua/custom/init.lua
-- Load personal configs in a protected way so missing files never crash startup
pcall(require, "custom.options")
pcall(require, "custom.mappings")

-- You can add more modules if you like:
-- pcall(require, "custom.statusline")
-- pcall(require, "custom.colors")
