-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- Paths of every file git reports as changed, worktree root relative -> absolute.
local function changed_files()
  local root = vim.fs.root(0, '.git')
  if not root then return {} end

  -- -z avoids git's quoting of paths with unusual characters
  local out = vim.system({ 'git', '-C', root, 'status', '--porcelain=v1', '-z', '-uall' }, { text = true }):wait()
  if out.code ~= 0 then return {} end

  local entries = vim.split(out.stdout or '', '\0', { trimempty = true })
  local files = {}
  local i = 1
  while i <= #entries do
    local status, path = entries[i]:sub(1, 2), entries[i]:sub(4)
    local abs = vim.fs.joinpath(root, path)
    -- Deleted files would just open an empty buffer
    if vim.uv.fs_stat(abs) then files[#files + 1] = abs end
    -- Renames and copies carry a second entry holding the original path
    i = i + (status:match '[RC]' and 2 or 1)
  end

  table.sort(files)
  return files
end

---@param offset integer 1 for the next changed file, -1 for the previous
local function goto_changed_file(offset)
  local files = changed_files()
  if #files == 0 then
    vim.notify('No changed files', vim.log.levels.INFO)
    return
  end

  local current = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  local idx
  for i, file in ipairs(files) do
    if vim.fs.normalize(file) == current then
      idx = i
      break
    end
  end

  -- Starting outside the change set enters it from whichever end you came at
  local target
  if not idx then
    target = offset > 0 and 1 or #files
  else
    target = (idx + offset - 1) % #files + 1
  end

  vim.cmd.edit(vim.fn.fnameescape(files[target]))
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    {
      '<leader>gs',
      -- 'show' opens the panel without stealing the cursor from your buffer
      function() require('neo-tree.command').execute { action = 'show', source = 'git_status', position = 'left', toggle = true } end,
      desc = 'git [s]tatus sidebar',
    },
    { ']g', function() goto_changed_file(1) end, desc = 'Next changed file' },
    { '[g', function() goto_changed_file(-1) end, desc = 'Previous changed file' },
  },
  opts = {
    filesystem = {
      follow_current_file = { enabled = true, leave_dirs_open = true },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    git_status = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)

    -- Neo-tree inherits CursorLine, which vscode.nvim sets to #222222 against a
    -- #1f1f1f background. Borrow the selection colour so the row actually reads.
    local function style_cursorline()
      local visual = vim.api.nvim_get_hl(0, { name = 'Visual', link = false })
      vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { bg = visual.bg or '#264f78', bold = true })
    end

    style_cursorline()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('neo-tree-highlights', { clear = true }),
      callback = style_cursorline,
    })

    -- The git_status source has no follow_current_file option, so mirror it by
    -- parking the panel's cursor on the current file. Neo-tree highlights its
    -- cursor line, so the entry stands out without the window taking focus.
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('neo-tree-follow-git-status', { clear = true }),
      callback = function(args)
        if vim.bo[args.buf].buftype ~= '' then return end
        local path = vim.api.nvim_buf_get_name(args.buf)
        if path == '' then return end

        local renderer = require 'neo-tree.ui.renderer'
        local state = require('neo-tree.sources.manager').get_state 'git_status'
        if state and renderer.window_exists(state) then pcall(renderer.focus_node, state, path, true) end
      end,
    })
  end,
}
