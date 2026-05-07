return {
  {
    "mason-org/mason.nvim",
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
        vtsls = {},
        jsonls = {},
        yamlls = {},
        marksman = {},
        taplo = {},
      },
    },
  },
}
