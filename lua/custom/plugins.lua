-- lua/custom/plugins.lua
return {
  -- LSP that never throws if servers are missing
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function()
      require "custom.lsp"
    end,
    dependencies = {
      -- Optional helpers; if user doesn't have them, it's fine
      { "williamboman/mason.nvim", opts = {} },
      { "williamboman/mason-lspconfig.nvim", opts = {} },
      { "hrsh7th/cmp-nvim-lsp", lazy = true },
    },
  },

  -- Quiet, best-effort formatting (won’t complain if tools are absent)
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "custom.conform"
    end,
  },

  -- Treesitter without forced installs (safe defaults)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require "custom.treesitter"
    end,
  },

  -- Any other utilities you like (kept lazy to avoid bloat/conflicts)
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "vim-scripts/a.vim",
    event = "VeryLazy",

    config = function()
      vim.keymap.set("n", "<leader>aa", "<cmd>A<cr>", { desc = "switch to [A]lternate file" })
      vim.keymap.set("n", "<leader>av", "<cmd>AV<cr>", { desc = "Switch to Alternate [V]ertical" })
      vim.keymap.set("n", "<leader>ah", "<cmd>AS<cr>", { desc = "Switch to Alternate [H]orizontal" })
      vim.keymap.set("n", "<leader>at", "<cmd>AT<cr>", { desc = "Switch to Alternate [T]ab" })
      vim.keymap.set("n", "<leader>an", "<cmd>AN<cr>", { desc = "Switch to Alternate Next" })

      vim.api.nvim_del_keymap("i", "<leader>ih")
      vim.api.nvim_del_keymap("i", "<leader>is")
      vim.api.nvim_del_keymap("i", "<leader>ihn")
    end,
  },
  {
    -- Over ssh navigator not working ? TRY 'sunaku/tmux-navigate',
    "alexghergh/nvim-tmux-navigation",
    event = "VeryLazy",
    config = function()
      local nvim_tmux_nav = require "nvim-tmux-navigation"

      nvim_tmux_nav.setup {
        disable_when_zoomed = true, -- defaults to false
      }

      vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
}
