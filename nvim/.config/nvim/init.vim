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

"coc config
" Use release branch (recommend)
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" vimm surround
Plug 'tpope/vim-surround'

" emmet
Plug 'mattn/emmet-vim'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
"Plug 'fannheyward/telescope-coc.nvim'

" rfc plugin (:RFC [vim regexp])
Plug 'mhinz/vim-rfc'

Plug 'airblade/vim-rooter'

Plug 'kyazdani42/nvim-web-devicons'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'tpope/vim-fugitive'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

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
call plug#end()

"colorscheme gruvbox
lua require('colorbuddy').colorscheme('onebuddy')

" coc config
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

" coc extensions
"let g:coc_global_extensions = [
"      \'coc-highlight',
"      \'coc-python',
"      \'coc-json', 
"      \'coc-html',
"      \'coc-css',
"      \'coc-tsserver',
"      \'coc-rust-analyzer'
"      \]

" show hint of word under cursor
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"nnoremap <silent> gh :call <SID>show_documentation()<CR>


"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  elseif (coc#rpc#ready())
"    call CocActionAsync('doHover')
"  else
"    execute '!' . &keywordprg . " " . expand('<cword>')
"  endif
"endfunction

" Symbol renaming.
"nmap <leader>rn <Plug>(coc-rename)

" Format current word
"nmap <leader>cf  <Plug>(coc-format-selected)
"vmap <leader>cf  <Plug>(coc-format-selected)

" Remap <C-f> and <C-b> for scroll float windows/popups.
"if has('nvim-0.4.0') || has('patch-8.2.0750')
"  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif

set signcolumn=yes

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

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
