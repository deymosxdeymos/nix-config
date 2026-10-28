vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local opt = vim.opt
opt.mouse = ''
opt.swapfile = false
opt.winborder = 'rounded'
opt.updatetime = 250
opt.tabstop = 2
opt.shiftwidth = 2
opt.signcolumn = 'yes'
opt.wrap = false
opt.ignorecase = true
opt.smartindent = true
opt.termguicolors = true
opt.undofile = true
opt.number = true
opt.clipboard = 'unnamedplus'
vim.diagnostic.config({ underline = true, severity_sort = true, virtual_text = false, virtual_lines = { current_line = true }, float = { border = 'rounded', source = 'if_many' } })

-- Follow macOS appearance, including changes made while Neovim is open.
if vim.fn.has('mac') == 1 then
  local function update_appearance()
    vim.system({ 'defaults', 'read', '-g', 'AppleInterfaceStyle' }, { text = true }, function(result)
      local background = result.code == 0 and result.stdout:match('Dark') and 'dark' or 'light'
      vim.schedule(function()
        if vim.o.background ~= background then vim.o.background = background end
      end)
    end)
  end
  update_appearance()
  vim.api.nvim_create_autocmd({ 'FocusGained', 'VimResume' }, { callback = update_appearance })
  local timer = assert(vim.uv.new_timer())
  timer:start(5000, 5000, update_appearance)
  vim.api.nvim_create_autocmd('VimLeavePre', { callback = function() timer:stop(); timer:close() end })
end

-- Run :PackInstall once to download these packages, then restart Neovim.
local packages = {
  { src = 'https://github.com/echasnovski/mini.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}
local packdir = vim.fn.stdpath('data') .. '/site/pack/core/opt/'
local installed = {}
for _, spec in ipairs(packages) do
  local name = spec.src:match('/([^/]+)$'):gsub('%.git$', '')
  if vim.fn.isdirectory(packdir .. name) == 1 then table.insert(installed, spec) end
end
if #installed > 0 then vim.pack.add(installed) end
vim.api.nvim_create_user_command('PackInstall', function()
  vim.pack.add(packages)
  vim.notify('Packages installed. Restart Neovim to load their configuration.')
end, {})

local function setup(module, options)
  local ok, plugin = pcall(require, module)
  if ok then plugin.setup(options or {}) end
  return ok
end
setup('mini.statusline', { use_icons = false })
setup('mini.pairs')
setup('mini.completion')
opt.completeopt = 'menuone,noselect,popup,fuzzy'
opt.shortmess:append('c')
setup('oil', { view_options = { show_hidden = true }, columns = {} })
setup('telescope', { defaults = { sorting_strategy = 'ascending', path_display = { 'smart' }, layout_config = { prompt_position = 'top' } } })

local map = vim.keymap.set
map({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to clipboard' })
map('n', 'gh', '0', { desc = 'Start of line' })
map('n', 'gl', '$', { desc = 'End of line' })
map('n', 'H', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', 'L', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('v', '<', '<gv')
map('v', '>', '>gv')
map('n', '<Esc>', '<cmd>nohlsearch<cr>')
map({ 'n', 'x' }, '<CR>', ':', { desc = 'Command line' })
map('n', '<leader>w', '<cmd>update<cr>', { desc = 'Write' })
map('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit' })
map('n', '<leader>Q', '<cmd>wqa<cr>', { desc = 'Write and quit all' })
map('n', '<leader>v', '<cmd>edit $MYVIMRC<cr>', { desc = 'Edit config' })
map('n', '<leader>a', '<cmd>edit #<cr>', { desc = 'Alternate file' })
map('n', '<leader>uw', function() vim.wo.wrap = not vim.wo.wrap; vim.wo.linebreak = vim.wo.wrap end, { desc = 'Toggle wrap' })
map('n', '<leader>t', '<cmd>split | terminal<cr>i', { desc = 'Split terminal' })
map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Terminal normal mode' })
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
for i = 1, 8 do map('n', '<leader>' .. i, '<cmd>tabnext ' .. i .. '<cr>') end
local function explorer()
  if not pcall(vim.cmd.Oil) then vim.cmd.Explore() end
end
map('n', '-', explorer, { desc = 'File explorer' })
map('n', '<leader>e', explorer, { desc = 'File explorer' })
local function picker(name, options)
  return function()
    local ok, builtin = pcall(require, 'telescope.builtin')
    if ok then builtin[name](options or {}) else vim.notify('Install Telescope with :PackInstall', vim.log.levels.WARN) end
  end
end
for keys, spec in pairs({
  fd = { 'find_files' }, fD = { 'find_files', { hidden = true } }, fg = { 'live_grep' },
  fw = { 'grep_string' }, sb = { 'buffers' }, so = { 'oldfiles' }, sh = { 'help_tags' },
  sd = { 'diagnostics' }, ss = { 'current_buffer_fuzzy_find' }, sk = { 'keymaps' },
  sg = { 'find_files', { hidden = true, no_ignore = true } },
}) do map('n', '<leader>' .. keys, picker(spec[1], spec[2]), { desc = spec[1] }) end

vim.api.nvim_create_autocmd('LspAttach', { callback = function(args)
  local function lspmap(keys, fn, desc) map('n', keys, fn, { buffer = args.buf, desc = desc }) end
  lspmap('gd', vim.lsp.buf.definition, 'Definition')
  lspmap('gD', vim.lsp.buf.declaration, 'Declaration')
  lspmap('gr', vim.lsp.buf.references, 'References')
  lspmap('gi', vim.lsp.buf.implementation, 'Implementation')
  lspmap('gy', vim.lsp.buf.type_definition, 'Type definition')
  lspmap('K', vim.lsp.buf.hover, 'Hover')
  lspmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
  lspmap('<leader>ca', vim.lsp.buf.code_action, 'Code action')
  lspmap('<leader>d', vim.diagnostic.open_float, 'Diagnostic')
  lspmap('<leader>lf', vim.lsp.buf.format, 'Format')
  lspmap('[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Previous diagnostic')
  lspmap(']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, 'Next diagnostic')
end })
-- Prefer each project's own binaries and configuration, including monorepos.
if vim.fn.isdirectory(packdir .. 'nvim-lspconfig') == 1 then
  local function local_bin(bufnr, name)
    local file = vim.api.nvim_buf_get_name(bufnr)
    local found = vim.fs.find('node_modules/.bin/' .. name, { path = vim.fs.dirname(file), upward = true, type = 'file' })[1]
    if found and vim.fn.executable(found) == 1 then return found end
    if vim.fn.executable(name) == 1 then return name end
  end
  local function typescript7(bufnr)
    local bin = local_bin(bufnr, 'tsc')
    if not bin then return false end
    local result = vim.system({ bin, '--version' }, { text = true }):wait(2000)
    local major = result.code == 0 and (result.stdout or ''):match('(%d+)%.%d+')
    return major and tonumber(major) >= 7 or false
  end
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
  vim.lsp.config('*', { capabilities = capabilities })
  for _, server in ipairs({ 'tsc', 'ts_ls', 'oxfmt', 'oxlint' }) do
    local original_root = vim.lsp.config[server].root_dir
    local name = server
    local executable = ({ tsc = 'tsc', ts_ls = 'typescript-language-server', oxfmt = 'oxfmt', oxlint = 'oxlint' })[name]
    local arguments = ({ tsc = { '--lsp', '--stdio' }, ts_ls = { '--stdio' }, oxfmt = { '--lsp' }, oxlint = { '--lsp' } })[name]
    vim.lsp.config(server, { cmd = function(dispatchers, config)
      local path = vim.fs.find('node_modules/.bin/' .. executable, { path = config.root_dir, upward = true, type = 'file' })[1]
      return vim.lsp.rpc.start(vim.list_extend({ path or executable }, arguments), dispatchers)
    end, root_dir = function(bufnr, on_dir)
      local available = server == 'tsc' and typescript7(bufnr)
        or server == 'ts_ls' and not typescript7(bufnr) and local_bin(bufnr, 'typescript-language-server')
        or server == 'oxfmt' and local_bin(bufnr, 'oxfmt')
        or server == 'oxlint' and local_bin(bufnr, 'oxlint')
      if available then original_root(bufnr, on_dir) end
    end })
    vim.lsp.enable(server)
  end
  for server, executable in pairs({ lua_ls = 'lua-language-server', rust_analyzer = 'rust-analyzer', cssls = 'vscode-css-language-server', tailwindcss = 'tailwindcss-language-server', ty = 'ty', ruff = 'ruff' }) do
    if vim.fn.executable(executable) == 1 then vim.lsp.enable(server) end
  end
  vim.api.nvim_create_autocmd('BufWritePre', { callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf, name = 'oxfmt' })
    if #clients > 0 then
      vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 3000, filter = function(client) return client.name == 'oxfmt' end })
    end
  end })
end
vim.api.nvim_create_autocmd('TextYankPost', { callback = function() vim.hl.on_yank() end })
vim.api.nvim_create_autocmd('TermOpen', { callback = function() vim.opt_local.number = false; vim.opt_local.relativenumber = false end })
