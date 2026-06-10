---@brief
---
--- https://github.com/regen100/cmake-language-server
---
--- CMake LSP Implementation

local mason_root = vim.fs.joinpath(vim.fn.stdpath('data'), 'mason')

local function resolve_executable()
  local candidates = {
    vim.fn.exepath('cmake-language-server'),
    vim.fs.joinpath(vim.env.HOME, '.local', 'bin', 'cmake-language-server'),
    vim.fs.joinpath(vim.env.HOME, '.local', 'cmake-lsp-venv', 'bin', 'cmake-language-server'),
    vim.fs.joinpath(mason_root, 'bin', 'cmake-language-server'),
    vim.fs.joinpath(mason_root, 'packages', 'cmake-language-server', 'venv', 'bin', 'cmake-language-server'),
  }

  for _, candidate in ipairs(candidates) do
    if candidate ~= '' and vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  return 'cmake-language-server'
end

---@type vim.lsp.Config
return {
  cmd = { resolve_executable() },
  filetypes = { 'cmake' },
  root_markers = { 'CMakeLists.txt', 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' },
  init_options = {
    buildDirectory = 'build',
  },
}
