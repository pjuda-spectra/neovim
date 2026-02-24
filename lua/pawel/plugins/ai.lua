return {
  {
    "yetone/avante.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "github/copilot.vim",
        config = function()
          -- Disable Copilot suggestions by default
          vim.g.copilot_enabled = false
          -- Keymap to toggle Copilot suggestions
          vim.keymap.set('n', '<leader>am', function()
            vim.g.copilot_enabled = not vim.g.copilot_enabled
            if vim.g.copilot_enabled then
              vim.notify('Copilot suggestions enabled')
            else
              vim.notify('Copilot suggestions disabled')
            end
          end, { desc = 'Toggle Copilot suggestions' })
        end,
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
    build = "make",
    opts = { provider = "copilot" },
  },
}
