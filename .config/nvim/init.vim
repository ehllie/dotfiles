set number numberwidth=2
set nocompatible
call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'wincent/terminus'
Plug 'lambdalisue/suda.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'tmsvg/pear-tree'
Plug 'michaeljsmith/vim-indent-object'
Plug 'ehllie/argtextobj.vim'
Plug 'sbdchd/neoformat'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
call plug#end()

" pear-tree config
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1

cmap w!! SudaWrite
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

