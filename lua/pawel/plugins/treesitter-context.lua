return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    enable = true,
    max_lines = 3,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 1,
    trim_scope = 'outer',
    mode = 'cursor',
    separator = nil,
  },
  config = function(_, opts)
    local tsc = require 'treesitter-context'
    tsc.setup(opts)
    vim.keymap.set('n', '<leader>tc', '<cmd>TSContextToggle<CR>', { desc = '[T]oggle treesitter [C]ontext' })
    vim.keymap.set('n', '[c', function() tsc.go_to_context(vim.v.count1) end, { silent = true, desc = 'Jump to context (upwards)' })
  end,
}
