set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number relativenumber
set nowrap
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set nohlsearch
set spelllang=en
set hidden
set scrolloff=8
"set colorcolumn=80


let mapleader = "\<Space>" 
let g:netrw_browse_split=3
let g:netrw_banner = 0
let g:netrw_winsize = 25

call plug#begin('~/.config/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'mbbill/undotree'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'

" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
call plug#end()

colorscheme gruvbox
set bg=dark


nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

nnoremap <F5> :UndotreeToggle<CR>
nnoremap <C-P> :FZF<CR>
