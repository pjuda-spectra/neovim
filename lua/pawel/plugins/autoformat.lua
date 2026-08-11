return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        local range = nil
        local mode = vim.api.nvim_get_mode().mode
        if mode == 'v' or mode == 'V' or mode == '\22' then
          local pos_v = vim.fn.getpos 'v'
          local pos_c = vim.fn.getpos '.'
          -- Normalize so 'start' is always before 'end' (selections can be made backwards)
          local start_pos, end_pos = pos_v, pos_c
          if pos_v[2] > pos_c[2] or (pos_v[2] == pos_c[2] and pos_v[3] > pos_c[3]) then
            start_pos, end_pos = pos_c, pos_v
          end
          range = {
            start = { start_pos[2], start_pos[3] - 1 },
            ['end'] = { end_pos[2], end_pos[3] },
          }
        end
        require('conform').format { async = true, lsp_format = 'fallback', range = range }
      end,
      mode = { 'n', 'x' },
      desc = '[F]ormat buffer or selection',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true, cmake = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- .h/.hpp headers resolve to the c/cpp filetypes, so they're covered here
      c = { 'clang-format' },
      cpp = { 'clang-format' },
    },
    formatters = {
      ['clang-format'] = {
        prepend_args = { '-style={IndentWidth: 4, TabWidth: 4, UseTab: Never}' },
      },
    },
  },
}
