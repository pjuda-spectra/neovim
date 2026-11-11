return {
  'karb94/neoscroll.nvim',
  event = 'VeryLazy',
  opts = {
    mappings = { -- Keys to be mapped to their corresponding default scrolling animation
      '<C-u>',
      '<C-d>',
      '<C-b>',
      '<C-f>',
      '<C-y>',
      '<C-e>',
      'zt',
      'zz',
      'zb',
    },
    hide_cursor = true, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    duration_multiplier = 0.5, -- Shorter animation leaves less room for a dropped frame to show
    easing = 'quadratic', -- Fast start, soft landing
    performance_mode = false, -- Enabled per-buffer for large files, see below
    ignored_events = { -- Events ignored while scrolling
      'WinScrolled',
      'CursorMoved',
      'CursorMovedI',
      'WinResized',
    },
  },
  config = function(_, opts)
    require('neoscroll').setup(opts)

    -- Drop syntax/treesitter highlighting mid-animation on files big enough
    -- that re-highlighting every frame is what makes the scroll stutter.
    vim.api.nvim_create_autocmd('BufReadPost', {
      group = vim.api.nvim_create_augroup('neoscroll-performance-mode', { clear = true }),
      callback = function(args)
        if vim.api.nvim_buf_line_count(args.buf) > 5000 then vim.b[args.buf].neoscroll_performance_mode = true end
      end,
    })
  end,
}
