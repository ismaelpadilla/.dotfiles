set nocompatible

set background=dark

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
set hidden " Hide buffers when switching between files

" netrw
let g:netrw_liststyle=3 " tree view by default
let g:netrw_winsize=25


call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'

"coc config
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Or build from source code by using yarn: https://yarnpkg.com
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

" vimm surround
Plug 'tpope/vim-surround'

" emmet
Plug 'mattn/emmet-vim'

call plug#end()

colorscheme gruvbox

" coc config
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" coc extensions
let g:coc_global_extensions = [
      \'coc-highlight',
      \'coc-python',
      \'coc-json', 
      \'coc-html',
      \'coc-css',
      \'coc-tsserver',
      \'coc-rust-analyzer'
      \]

" show hint of word under cursor
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> gh :call <SID>show_documentation()<CR>


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Format current word
nmap <leader>cf  <Plug>(coc-format-selected)
vmap <leader>cf  <Plug>(coc-format-selected)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

set signcolumn=yes

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Y behaves like C or D
nnoremap Y yg$

" undo break points
inoremap . .<c-g>u
inoremap , ,<c-g>u
inoremap ; ;<c-g>u

" jumplist mutation (if jumping more than 5 lines up or down, modify jumplist)
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
