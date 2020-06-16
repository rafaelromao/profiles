" set default filetypes
augroup MyVimrc
    autocmd!
    autocmd BufNewFile,BufRead COMMIT_EDITMSG set ft=gitcommit
    autocmd BufNewFile,BufRead *.vb set ft=vbnet
    autocmd BufNewFile,BufRead *._ps1 set ft=ps1
    autocmd BufNewFile,BufRead *.msbuild set ft=xml
    autocmd BufNewFile,BufRead *.targets set ft=xml
    autocmd BufNewFile,BufRead *.properties set ft=xml
    autocmd BufNewFile,BufRead *.tasks set ft=xml
    autocmd BufNewFile,BufRead *.proj set ft=xml
    autocmd BufNewFile,BufRead *.props set ft=xml
    autocmd BufNewFile,BufRead *.build set ft=xml
    autocmd BufNewFile,BufRead *.wxi set ft=xml
    autocmd BufNewFile,BufRead *.wxs set ft=xml
    autocmd BufNewFile,BufRead *.vim set ft=vim
    autocmd BufNewFile,BufRead vimrc set ft=vim
    autocmd BufNewFile,BufRead *.cs set ft=cs
    autocmd BufNewFile,BufRead **/.kube/config set ft=yaml
    autocmd BufNewFile,BufRead gitconfig set ft=gitconfig

    autocmd BufWritePost Shortcuts.ahk call system('start ' . expand('%'))

    autocmd FileType gitcommit setlocal enc=utf8 spell
    autocmd FileType gitcommit normal! gg

    autocmd FileType yaml,json,xml setlocal tabstop=2 shiftwidth=2 enc=utf8
    autocmd FileType ruby,eruby set filetype=ruby.eruby.chef
    autocmd FileType javascript,javascript.jsx,*.json setlocal tabstop=2 shiftwidth=2
    autocmd FileType markdown set spell

    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow

    autocmd FileType typescript JsPreTmpl
    autocmd FileType typescript syn clear foldBraces
    autocmd FileType typescript set ts=2 sw=2
    autocmd FileType html set ts=2 sw=2

    au BufReadCmd *.jar,*.xpi,*.docx,*.nupkg call zip#Browse(expand("<amatch>"))
    if has('gui') && (has('win32') || has('win64'))
        au GUIEnter * simalt ~x
    endif
augroup END

