return {
  'Mofiqul/vscode.nvim',
  priority = 1000,
  config = function()
    require('vscode').setup {
      style = 'dark',
      transparency = true,
      styles = {
        comments = { italic = false },
      },
    }
    vim.cmd.colorscheme 'vscode'
  end,
}
