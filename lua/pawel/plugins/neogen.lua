return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    local AUTHOR = 'Pawel Juda'

    local function doxygen_template()
      local template = vim.deepcopy(require('neogen.templates.doxygen'))
      for i, entry in ipairs(template) do
        if entry[2] == ' * @file' then
          table.insert(template, i + 1, { nil, ' * @author ' .. AUTHOR, { no_results = true, type = { 'file' } } })
          table.insert(template, i + 2, { nil, ' * @date ' .. os.date('%Y-%m-%d'), { no_results = true, type = { 'file' } } })
          break
        end
      end
      return template
    end

    local lang_template = {
      template = {
        annotation_convention = 'doxygen',
        doxygen = doxygen_template(),
      },
    }

    local neogen_opts = {
      enabled = true,
      input_after_comment = true,
      languages = {
        c = lang_template,
        cpp = lang_template,
      },
    }

    local function setup_neogen()
      neogen_opts.languages.c.template.doxygen = doxygen_template()
      neogen_opts.languages.cpp.template.doxygen = neogen_opts.languages.c.template.doxygen
      require('neogen').setup(neogen_opts)
    end

    setup_neogen()

    vim.keymap.set('n', '<leader>df', function()
      require('neogen').generate { type = 'func' }
    end, { silent = true, desc = 'Generate Doxygen function comment' })

    vim.keymap.set('n', '<leader>dF', function()
      setup_neogen()
      require('neogen').generate { type = 'file' }
    end, { silent = true, desc = 'Generate Doxygen file header' })
  end,
  version = '*',
}
