set nocompatible

"block cursor
set guicursor=

set background=dark

set mouse=a

" colors on tmux
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let mapleader=" "

syntax on "enable syntax highlighting

set laststatus=2 " always show status line
set statusline=%F " show full path to file in status line
set number "show line numbers
set showcmd "show commands at bottom
set cursorline "highlight cursor line
set scrolloff=8 "keep cursor centered vertically

" Line numbers
set relativenumber
set nu

" *Indentation*:
filetype indent on
set shiftwidth=4
set tabstop=4
set expandtab

set wildmenu "visual autocomplete for command menu
set showmatch "highlight matching parentheses

set incsearch "search as characters are entered
set hlsearch "highlight matches
" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" disable ex mode
:nnoremap Q <Nop>

set foldmethod=indent
set foldlevelstart=99 "unfold on startup

nnoremap <leader>html :0r ~/.vim/snippets/html.html<CR>6ggcit

" Search into subfolders
set path+=**
set wildignore+=**/node_modules/**

" netrw
let g:netrw_liststyle=3 " tree view by default
let g:netrw_winsize=25


call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'

" vim surround
Plug 'tpope/vim-surround'

" emmet
Plug 'mattn/emmet-vim'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'

" rfc plugin (:RFC [vim regexp])
Plug 'mhinz/vim-rfc'

Plug 'airblade/vim-rooter'

Plug 'kyazdani42/nvim-web-devicons'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-angular'

Plug 'tpope/vim-fugitive'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind-nvim'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
" Plug 'rafamadriz/friendly-snippets' --TODO look into this

Plug 'tjdevries/colorbuddy.vim'
Plug 'Th3Whit3Wolf/onebuddy'

"Plug 'itchyny/lightline.vim'
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'kyazdani42/nvim-web-devicons'

Plug 'simrat39/rust-tools.nvim'
Plug 'nvim-lua/popup.nvim'

Plug 'numToStr/Comment.nvim'

Plug 'weilbith/nvim-code-action-menu'

Plug 'kyazdani42/nvim-tree.lua'

Plug 'lewis6991/gitsigns.nvim'

" Plug 'github/copilot.vim'

Plug 'https://github.com/ismaelpadilla/comment-helper.nvim'
Plug '~/code/comment-helper-lua.nvim/'

Plug 'ThePrimeagen/harpoon'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

Plug 'j-hui/fidget.nvim'

Plug 'mfussenegger/nvim-jdtls'

Plug 'lukas-reineke/indent-blankline.nvim' " add indent line

Plug 'mfussenegger/nvim-dap'
Plug 'leoluz/nvim-dap-go'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'

Plug 'ggandor/leap.nvim'

Plug 'mfussenegger/nvim-lint'
call plug#end()

"colorscheme gruvbox
lua require('colorbuddy').colorscheme('onebuddy')

set signcolumn=yes

" undo break points
inoremap . .<c-g>u
inoremap , ,<c-g>u
inoremap ; ;<c-g>u

" jumplist mutation (if jumping more than 5 lines up or down, modify jumplist)
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fd <cmd>lua require('telescope.builtin').diagnostics()<cr>

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" replace currently selected text with default register
" without yanking it
xnoremap <leader>p "_dP

" copy from clipboard
nnoremap <leader>pp "+p

" yank to clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

lua require("luaconfig")

"let & path. = ",".system("git rev-parse --show-toplevel | tr -d '\\n'")

nnoremap <leader>ex :Lex %:p:h<cr>
nnoremap <leader>pv :Sex!<cr>

" treesitter highlight
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }

" nvim cmp
set completeopt=menu,menuone,noselect

" quicklist navigation
nnoremap <C-k> :cprev<CR>zz
nnoremap <C-j> :cnext<CR>zz

" quicklist navigation
nnoremap <leader><C-k> :lprev<CR>zz
nnoremap <leader><C-j> :lnext<CR>zz

" split windows to theright
set splitright

lua << END
require'lualine'.setup({options = {theme = 'ayu_mirage'}})
END


" nvimtree 
nnoremap <C-n> :NvimTreeToggle<CR>

" highlight on yank
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END

set list
set listchars+=eol:↴
" lua alternative:
" vim.opt.list = true
" vim.opt.listchars:append("eol:↴")

nnoremap <leader>w <cmd>write<cr>
