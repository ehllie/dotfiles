set number numberwidth=2
set nocompatible
call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'wincent/terminus'
Plug 'lambdalisue/suda.vim'
Plug 'francoiscabrol/ranger.vim'
call plug#end()
cmap w!! SudaWrite
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>
