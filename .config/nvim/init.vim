call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'wincent/terminus'
Plug 'lambdalisue/suda.vim'
call plug#end()
cmap w!! SudaWrite
