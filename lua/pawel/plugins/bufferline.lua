-- A snazzy buffer line (with tabpage integration) for Neovim
-- https://github.com/akinsho/bufferline.nvim

return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = 'VeryLazy',
  keys = {
    { '<S-l>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
    { '<leader>bp', '<cmd>BufferLineTogglePin<CR>', desc = 'Toggle [P]in' },
    { '<leader>bd', '<cmd>bdelete<CR>', desc = '[D]elete buffer' },
    { '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', desc = 'Delete [O]ther buffers' },
  },
  opts = {
    options = {
      diagnostics = 'nvim_lsp',
      always_show_bufferline = false,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          highlight = 'Directory',
          text_align = 'left',
          separator = true,
        },
      },
    },
  },
}
