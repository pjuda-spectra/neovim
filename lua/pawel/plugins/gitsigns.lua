return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '▁' },
      topdelete = { text = '▔' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '▁' },
      topdelete = { text = '▔' },
      changedelete = { text = '▎' },
    },
    attach_to_untracked = true,
    preview_config = { border = 'rounded' },
    current_line_blame_opts = { delay = 300, ignore_whitespace = true },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Jump to previous git [c]hange' })

      map('n', ']C', function() gitsigns.nav_hunk 'last' end, { desc = 'Jump to last git [C]hange' })
      map('n', '[C', function() gitsigns.nav_hunk 'first' end, { desc = 'Jump to first git [C]hange' })

      -- Actions
      -- visual mode
      map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
      map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })
      -- normal mode
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk (toggles on staged signs)' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
      map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line' })
      map('n', '<leader>hB', gitsigns.blame, { desc = 'git [B]lame file' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
      map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
      map('n', '<leader>hc', function()
        local closed = false
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
          if vim.startswith(name, 'gitsigns://') then
            local ok, err = pcall(vim.api.nvim_win_close, win, false)
            if ok then
              closed = true
            else
              vim.notify(tostring(err), vim.log.levels.WARN)
            end
          end
        end
        if not closed then
          vim.notify('No gitsigns diff window open', vim.log.levels.INFO)
        elseif vim.wo.diff then
          vim.cmd.diffoff()
        end
      end, { desc = 'git [c]lose diff' })
      map('n', '<leader>hq', gitsigns.setqflist, { desc = 'git hunks to [q]uickfix (buffer)' })
      map('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = 'git hunks to [Q]uickfix (repo)' })
      -- Toggles
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git [w]ord diff' })
      -- Text object
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = '[i]nner git [h]unk' })
    end,
  },
}
