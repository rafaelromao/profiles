" Disable SnipMate snippets in UltiSnippets
let g:UltiSnipsEnableSnipMate = 0

" Set Vimfiler as defualt explorer
let g:vimfiler_as_default_explorer = 1
let g:jsx_ext_required = 0


let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|node_modules|bin|obj)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

source <sfile>:h/lightline.vim

" " Check OmniSharp load needed
" if has('python') || has('python3')
    " source <sfile>:h/OmniSharp.vim
" 
    " if has('lua')
        " source <sfile>:h/neocomplete.vim
    " endif
" endif

