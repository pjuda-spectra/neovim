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
    { '<leader>gD', '<cmd>DiffviewOpen -- %<CR>', desc = 'git [D]iffview current file' },
    { '<leader>gc', '<cmd>DiffviewClose<CR>', desc = 'git diffview [c]lose' },
    {
      '<leader>gC',
      function()
        -- Grab whatever file the view is on before it's torn down, so closing
        -- lands on that file instead of whatever the tabpage held beforehand.
        local path, cursor
        local view = require('diffview.lib').get_current_view()
        if view then
          local ok, file = pcall(view.infer_cur_file, view)
          if ok and file then path = file.absolute_path end
          if not view.panel:is_focused() then cursor = vim.api.nvim_win_get_cursor(0) end
        end

        vim.cmd 'DiffviewClose'

        if path then
          vim.cmd.edit(vim.fn.fnameescape(path))
          if cursor then pcall(vim.api.nvim_win_set_cursor, 0, cursor) end
        end
      end,
      desc = 'git diffview [C]lose, keeping the reviewed file open',
    },
    { '<leader>gh', '<cmd>DiffviewFileHistory<CR>', desc = 'git diffview file [h]istory (repo)' },
    { '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', desc = 'git diffview [f]ile history (current)' },
  },
  opts = {},
}
