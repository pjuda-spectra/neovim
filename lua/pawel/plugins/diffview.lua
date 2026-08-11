-- Diffview is a single tabpage interface for easily cycling through diffs
-- and reviewing the git history
-- https://github.com/sindrets/diffview.nvim

return {
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewFileHistory',
  },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = 'git [d]iffview open' },
    { '<leader>gc', '<cmd>DiffviewClose<CR>', desc = 'git diffview [c]lose' },
    { '<leader>gh', '<cmd>DiffviewFileHistory<CR>', desc = 'git diffview file [h]istory (repo)' },
    { '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', desc = 'git diffview [f]ile history (current)' },
  },
  opts = {},
}
