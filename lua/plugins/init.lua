return {

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.treesitter"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lspconfig" },
    config = function()
      require "configs.mason-lspconfig"
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  {
    "rshkarin/mason-nvim-lint",
    event = "VeryLazy",
    dependencies = { "nvim-lint" },
    config = function()
      require "configs.mason-lint"
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          cuda = { "clang-format" },
          h = { "clang-format" },
        },
        format_on_save = {
          lsp_fallback = true,
          timeout_ms = 1000,
        },
      }
    end,
  },
  {
    "zapling/mason-conform.nvim",
    event = "VeryLazy",
    dependencies = { "stevearc/conform.nvim" },
    config = function()
      require("mason-conform").setup()
    end,
  },
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
  {
    "robitx/gp.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gp").setup {
        -- 1) Disable OpenAI (since you want to use Ollama locally)
        providers = {
          openai = { disable = true },

          -- 2) Enable Ollama provider pointing at localhost:11434
          ollama = {
            disable = false,
            endpoint = "http://localhost:11434/v1/chat/completions",
          },
        },

        -- 3) Declare exactly one “agent” table per model you want. The `name` field below must be unique.
        agents = {
          {
            name = "ChatOllamaLlama3.1-8B",
            disable = true,
          },
          {
            provider = "ollama",
            name = "ChatOllamaLlama3.1-8B",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = {
              model = "llama3.2",
              temperature = 0.6,
              top_p = 1,
              min_p = 0.05,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.",
          },
          {
            provider = "ollama",
            name = "CodeOllamaLlama3.1-8B",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = {
              model = "llama3.2",
              temperature = 0.4,
              top_p = 1,
              min_p = 0.05,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").code_system_prompt,
          },
        },
      }

      local function keymapOptions(desc)
        return {
          noremap = true,
          silent = true,
          nowait = true,
          desc = "GPT prompt " .. desc,
        }
      end

      -- Optional: keymaps to invoke chat or code assistance
      vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions "Visual Chat Paste")
      vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions "Visual Chat New vsplit")
      vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", keymapOptions "New Chat vsplit")

      -- Prompt commands
      vim.keymap.set({ "n", "i" }, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions "Inline Rewrite")
      vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions "Visual Rewrite")
      vim.keymap.set({ "n", "i" }, "<C-g>ge", "<cmd>GpEnew<cr>", keymapOptions "GpEnew")
    end,
  },
}
