-- Установка lazy.nvim, если он не установлен
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Настройка плагинов через lazy.nvim
require('lazy').setup({
  { 'tpope/vim-sensible' },
  { 'ryanoasis/vim-devicons' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'lewis6991/gitsigns.nvim' },
  { 'romgrk/barbar.nvim' },
  { 'glepnir/galaxyline.nvim' },
  { 'SmiteshP/nvim-gps' },
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
  { 'mfussenegger/nvim-dap' },
  { 'yamatsum/nvim-cursorline' },
  { 'kevinhwang91/promise-async' },
  { 'josa42/coc-go', run = 'yarn install --frozen-lockfile' },
  { 'clangd/coc-clangd', run = 'yarn install --frozen-lockfile' },
  { 'neoclide/coc-rls', run = 'yarn install --frozen-lockfile' },
  { 'voldikss/vim-floaterm' },
  { 'folke/tokyonight.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { "rose-pine/neovim", name = "rose-pine" },
  { 'nvim-tree/nvim-tree.lua' },
  { 'windwp/nvim-autopairs' },
  { 'vim-airline/vim-airline' },
  { 'vim-airline/vim-airline-themes' },
  { 'tpope/vim-fugitive' },
  { 'sheerun/vim-polyglot' },
  { 'b3nj5m1n/kommentary' },
  { 'jeetsukumaran/vim-buffergator' },
  { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } },
  { 'goolord/alpha-nvim' },
  { 'folke/which-key.nvim' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'L3MON4D3/LuaSnip' },
  { 'rafamadriz/friendly-snippets' },
  { 'neovim/nvim-lspconfig' },
  { 'typeddjango/django-stubs' },
  { 'onsails/lspkind-nvim' }
})

-- Настройка nvim-cmp
local cmp = require'cmp'
local lspkind = require'lspkind'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require('luasnip').jumpable(-1) then
        require('luasnip').jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- Добавляем маппинги для стрелочек
    ['<Down>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<Up>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 'c' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      before = function(entry, vim_item)
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[Snip]",
          nvim_lua = "[Lua]",
          latex_symbols = "[Latex]",
        })[entry.source.name]
        return vim_item
      end,
    }),
  },
  experimental = {
    ghost_text = true,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Настройка LSP с использованием nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.hover()
    end
  })
end

nvim_lsp.pyright.setup {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly"
      }
    }
  },
  capabilities = capabilities,
  on_attach = on_attach,
}

nvim_lsp.gopls.setup {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
}

local luasnip = require'luasnip'
require("luasnip.loaders.from_vscode").lazy_load()

vim.cmd('luafile /Users/aroslavgladkij/.config/nvim/galaxy_line_config.lua')

vim.api.nvim_create_autocmd({"BufReadPost", "FileReadPost"}, {
  pattern = "*",
  command = "normal! zR"
})

vim.api.nvim_set_keymap("n", "<S-C-t>", ":FloatermToggle<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("t", "<S-C-t>", "<C-\\><C-n>:FloatermToggle<CR>", { silent = true, noremap = true })

require('nvim-tree').setup()
vim.api.nvim_set_keymap("n", ",m", ":NvimTreeToggle<CR>", { silent = true, noremap = true })

vim.o.encoding = "UTF-8"
vim.wo.number = true
vim.cmd('syntax on')
vim.cmd('colorscheme rose-pine-moon')

vim.g.airline_extensions_tabline_enabled = 1
vim.api.nvim_set_keymap("n", "<C-h>", ":bprevious<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":bnext<CR>", { silent = true, noremap = true })

require('nvim-autopairs').setup{}

vim.cmd('highlight Normal ctermbg=none guibg=none')
vim.cmd('highlight NonText ctermbg=none guibg=none')

vim.g.kommentary_create_default_mappings = 1

vim.api.nvim_set_keymap("n", "<leader>bg", ":BuffergatorOpen<CR>", { silent = true, noremap = true })

require('gitsigns').setup {
  numhl = false,
  linehl = false,
  watch_gitdir = {
    interval = 1000,
  },
  attach_to_untracked = true,
  current_line_blame = false,
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
}

vim.api.nvim_set_keymap('n', '<leader>gs', ':G<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', { noremap = true, silent = true })

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "🔍 ",
    selection_caret = " ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
        preview_width = 0.55,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter = require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
    path_display = {"truncate"},
    winblend = 10,
    border = {},
    borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
    color_devicons = true,
    use_less = true,
    set_env = {['COLORTERM'] = 'truecolor'},
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })

vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'GitGutterAdd' })
vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'GitGutterChange' })
vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'GitGutterChangeDelete' })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'GitGutterDelete' })
vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'GitGutterDelete' })

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "javascript", "html", "css", "go" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

local alpha = require'alpha'
local dashboard = require'alpha.themes.dashboard'
dashboard.section.header.val = {
  '                      .\',\'.,',
  '                .,lkKNWMMMWNO,',
  '              ;kNWMMWWMMMMMMMWx\'',
  '           .:l;\'.lxKK.;KMMOcKMMX.',
  '           .   ......   dWl \'NMMK.',
  '                    ..   kO  OdlN:',
  '                       . ,X. :, \'d.',
  '                         .Kc  .   cl',
  '                          .:    \'o00.',
  '                  .           :KWMXo.',
  '                .lOl         ;NMMMMMMK,',
  '               .\'. .         .;c:kMK0WX.',
  '                 \'.              ,W;.NW\'',
  '                ,\'               \'Xl.dNl',
  '               .;                     .,',
}
dashboard.section.buttons.val = {
  dashboard.button( "e", "📃  New file" , ":ene <BAR> startinsert <CR>"),
  dashboard.button( "f", "📁 Find file", ":Telescope find_files<CR>"),
  dashboard.button( "r", "🕙  Recently used files" , ":Telescope oldfiles<CR>"),
  dashboard.button( "p", "🧰 Recent projects", ":Telescope projects<CR>"),
  dashboard.button( "w", "🗃️ Explorer", ":NvimTreeToggle<CR>"),
  dashboard.button( "q", "🚪 Quit NVIM" , ":qa<CR>"),
}
dashboard.section.footer.val = {
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "Buy me a coffee ☕",
  "BTC: bc1qxg00j02a6973yr2y5007cjmmk2h9qnr97mkul5",
  "USDT(TRC20): TLx9HHPdT1i85zQKd7Ne1xfZAPdbMk34QG",
  "",
  "Ps: You can delete this text. To do this, remove lines 291-305 in init.lua file"
}
alpha.setup(dashboard.opts)

require('which-key').setup {}

vim.api.nvim_set_keymap('n', '<C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-v>', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-v>', '"+p', { noremap = true, silent = true })

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h24"
elseif vim.fn.exists("g:goneovim") == 1 then
  vim.o.guifont = "JetBrainsMono Nerd Font:h24"
elseif vim.fn.has("gui_running") == 1 then
  vim.o.guifont = "JetBrainsMono Nerd Font:h24"
else
  -- Возможно, придется использовать другой метод для изменения размера шрифта
end

vim.o.updatetime = 300  -- Устанавливаем время задержки курсора в миллисекундах

