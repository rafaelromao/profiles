"Set NeoBundle at runtimepath

let bundlesPath=$HOME .'/.bundles'

if !isdirectory(bundlesPath)
    call mkdir(bundlesPath, "p")
endif

let neoBundlePath=bundlesPath . '/neobundle.vim'

if !isdirectory(neoBundlePath) && confirm("Install NeoBundle?", "&Yes\n&No")
   echom system('git clone https://github.com/Shougo/neobundle.vim ' . neoBundlePath)
endif

if isdirectory(neoBundlePath)
    execute ('set rtp+=' . neoBundlePath)

    source <sfile>:h/configure-neobundle.vim

    let s:cmd = 'nnoremap <leader>ev :e ' . expand('<sfile>:h') . '/neobundle.vim <cr>'
    execute s:cmd

    augroup NeobundleMappings
        autocmd!

        let s:cmd = 'autocmd BufWritePost neobundle.vim :source ' . expand('<sfile>:h') . '/configure-neobundle.vim'
        execute s:cmd

    augroup END

endif


