return {
  {
    "williamboman/mason.nvim", -- GitHub user/repo
    build = ":MasonUpdate",     -- Run this command after install/update
    config = function()
      require("mason").setup()
    end,
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "codelldb" -- for c++ debugging
      },
    },
    lazy = false,               -- Load during startup (eagerly)
    priority = 1000             -- Load this early (important if other plugins depend on it)
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "nvim-cmp" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "ts_ls", "emmet_ls" }
      })
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities();
            on_attach = function(_, bufnr)
              local opts = { buffer = bufnr, desc = "Go to definition" }
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            end
          })
        end,
        ["emmet_ls"] = function()
          require("lspconfig").emmet_ls.setup({
            filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'svelte', 'vue' },
          })
        end
      })
      -- require("lspconfig").clangd.setup({
      --   -- cmd = { "clangd", "--background-index"}
      --   -- filetypes = { "c", "cpp" }
      --   -- root_dir = require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt", ".git")
      --   -- capabilities = require("cmp_nvim_lsp").default_capabilities()
      --   -- init_options = {
      --   --   fallbackFlags = { "--std=c23" }
      --   -- }

      --   -- a function that runs when the language server attaches to a buffer (typically used to setup buffer-local keybindings)
      --   -- on_attach = function(client, bufnr)
      --     -- client.server_capabilities.signatureHelpProvider = false
      --     -- on_attach(client, bufnr)
      --   -- end
      --   capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- })
      -- require("lspconfig").ts_ls.setup({
      --   capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- })
      -- require("lspconfig").emmet_ls.setup({
      --   filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'svelte', 'vue' },
      -- })
    end
  },
  -- lazydev.nvim used to help with lua language server for configuration of neovim
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
  },
  -- dap
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- config required
      local dap = require("dap")
      dap.adapters.codelldb = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
      }
      dap.set_log_level("TRACE")
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim", -- closes the gap between mason.nvim and nvim-dap plugin
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap"
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    event = "VeryLazy",
    config = function()
      require("lazydev").setup({
        library = { "nvim-dap-ui" },
      })
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- Auto open UI when debugging starts, close when it ends
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Key mappings
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugger" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<Leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Set Conditional Breakpoint" })
      vim.keymap.set("n", "<Leader>du", require("dapui").toggle, { desc = "Toggle DAP UI" })

    end
  },
  -- task runner helpful for prelaunch tasks
  {
    'stevearc/overseer.nvim',
    opts = {},
  },
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' }
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    'tpope/vim-sleuth'
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "bash", "c", "cpp", "go", "gomod", "gosum",
          "html", "javascript", "json", "lua", "vim", "vimdoc", "query",
          "markdown", "markdown_inline", "python", "toml", "tsx", "typescript",
          "yaml" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Leader>ss",
            node_incremental = "<Leader>si",
            scope_incremental = "<Leader>sc",
            node_decremental = "<Leader>sd",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
          },
        },
        autotag = {
          enable = true
        },
        matchup = {
          enable = true
        },
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'v', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true or false
            include_surrounding_whitespace = true,
          },
        },

      }
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects"
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      'neovim/nvim-lspconfig', -- collection of configs for built-in LSP client
      'hrsh7th/cmp-nvim-lsp',  -- LSP source for nvim-cmp
      'hrsh7th/cmp-buffer',    -- adds autocompletion from current buffer words
      'hrsh7th/cmp-path',      -- adds filesystem path completions for :e or :w
      'hrsh7th/cmp-cmdline',   -- enables completions in command-line mode (for : commands or / searches)
      'L3MON4D3/LuaSnip',
      "saadparwaiz1/cmp_luasnip", -- connect cmp to LuaSnip
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.scroll_docs(-4),
            ['<C-n>'] = cmp.mapping.scroll_docs(4),
            ['<C-space>'] = cmp.mapping.complete(),
            ['<C-b>'] = cmp.mapping.select_prev_item(),
            ['<C-f>'] = cmp.mapping.select_next_item(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'path' },
          -- { name = 'cmd-line' },
        }, {
          { name = 'buffer' },
        }),

      })
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },
}

--
--
