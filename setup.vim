" setup preferences
set shiftwidth=4 tabstop=4
set nobackup
set noundofile
set nowritebackup
set nowrap
set ignorecase
set nu
set expandtab
set incsearch hlsearch
set hidden
set showcmd
set scrolloff=0
if v:version >= 800
    set nofixeol
endif
set backspace=indent,eol,start
set completeopt=menu
set laststatus=2
set clipboard=
set nrformats-=octal
set diffopt+=vertical

let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
let g:netrw_silent= 1
