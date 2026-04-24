return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "gopls",
        "lua-language-server",
        "pyright",
        "ruff",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
        "typescript-language-server",
        "vtsls",
        "json-lsp",
        "yaml-language-server",
        "marksman",
        "taplo",
        "prettierd",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        gopls = {},
        lua_ls = {},
        pyright = {},
        rust_analyzer = {},
        jsonls = {},
        yamlls = {},
        marksman = {},
        taplo = {},
      },
    },
  },
}
