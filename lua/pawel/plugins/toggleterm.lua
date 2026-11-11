return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {}
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        direction = 'float',
        hidden = true,
        float_opts = { border = 'rounded' },
        on_open = function(term)
          -- Escape is lazygit's "go back" key, but the global <Esc><Esc> terminal
          -- mapping swallows it and drops the window into normal mode instead.
          -- nowait sends the first Escape straight through without waiting.
          vim.keymap.set('t', '<Esc>', '<Esc>', { buffer = term.bufnr, nowait = true })
        end,
      }
      vim.keymap.set('n', '<leader>lg', function() lazygit:toggle() end, { desc = 'Open lazygit in a floating terminal' })

      -- Toggle terminal with leader + tt
      vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
    end,
  },
}
