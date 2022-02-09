set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number
set nowrap
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
set nohlsearch
set spelllang=en
set hidden
set scrolloff=8
set laststatus=2
"set colorcolumn=80
set termguicolors


let mapleader = "\<Space>"
let g:netrw_browse_split=3
let g:netrw_banner = 0
let g:netrw_winsize = 25

" Install vim-plug if not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.config/nvim/plugged')
Plug 'morhetz/gruvbox'
Plug 'mbbill/undotree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'tell-k/vim-autopep8'

" LSP + completion
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " run :TSInstall python etc.
Plug 'hrsh7th/nvim-cmp'
" Python
Plug 'heavenshell/vim-pydocstring', {'do': 'make install', 'for': 'python' }  

call plug#end()

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

let g:gruvbox_invert_selection='0'

colorscheme gruvbox
set bg=dark

let g:completion_matchin_strategy_list = ['exact', 'substring', 'fuzzy']

set completeopt=menuone,noselect
"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_smart_case = 1

lua << EOF
require('telescope').setup {
    defaults = {
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        generic_sorter =  require'telescope.sorters'.get_fzy_sorter,

        prompt_prefix = " >",
        color_devicons = true,

        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-x>"] = false,
                },
            },
        },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
            }
        }
    }
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
EOF

lua require'lspconfig'.bashls.setup{}
lua require'lspconfig'.pyright.setup{}



" lua require'lspconfig'.pyright.setup{ on_attach=require'compe'.on_attach}
" lua require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
" imap <tab> <Plug>(completion_smart_tab)
" imap <s-tab> <Plug>(completion_smart_s_tab)


nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>q :wincmd q<CR>

nnoremap <F5> :UndotreeToggle<CR>
nnoremap <silent> <F6> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
nnoremap <leader>gs :Git<CR>
" imap <F5> <Esc>:w<CR>:!clear;python %<CR>




" telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>


" Autocommands
autocmd FileType yaml setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
autocmd FileType python noremap <buffer> <F9> <Plug>(pydocstring)
" autocmd FileType python setlocal tabstop=4 shiftwidth=4 smarttab expandtab



let g:pydocstring_formatter = 'google'


