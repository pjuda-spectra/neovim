return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {}
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({ cmd = 'lazygit', direction = 'float' })
      vim.keymap.set('n', '<leader>lg', function()
        lazygit:toggle()
      end, { desc = 'Open lazygit in a floating terminal' })
    end,
  },
}
