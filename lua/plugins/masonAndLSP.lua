return {
  -- pkg manager for LSP Servers, linters, formatters and debuggers
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
  -- bridges mason.nvim with lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "nvim-cmp" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "ts_ls", "emmet_ls", "hls", "svelte" }
      })
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities();
            on_attach = function(_, bufnr)
              local opts = { buffer = bufnr, desc = "Go to definition/references" }
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
              vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
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
  -- gives good configs for lsp clients
  {
    "neovim/nvim-lspconfig",
  },
  -- lazydev.nvim used to help configuring lua language server for editing
  -- neovim config
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
  },
}
