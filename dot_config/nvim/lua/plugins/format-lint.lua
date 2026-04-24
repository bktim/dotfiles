return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        bash = { "shfmt" },
        go = { "gofmt" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        python = { "ruff_format", "ruff_fix" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        toml = { "taplo" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        yaml = { "prettierd" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        bash = { "shellcheck" },
        sh = { "shellcheck" },
      },
    },
  },
}
