call neobundle#begin($HOME . '/.bundles')
NeoBundleFetch 'Shougo/neobundle.vim'

source <sfile>:h/neobundle.vim

call neobundle#end()

if !has('nvim')
    NeoBundleCheck
endif
