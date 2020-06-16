source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

"use TEMP dir for swap in windows
set directory=$TEMP

let s:curlrc = expand('~/.curlrc')
if filereadable(s:curlrc)
    let g:netrw_http_xcmd = '-K' . s:curlrc . ' -o'
endif

function! SetApiKey(apikey)
    let l:curlrc = expand('~/.curlrc')
    let g:netrw_http_xcmd = '-H apikey:' . a:apikey . ' -K' . l:curlrc . ' -o'
endfunction

command! -nargs=+ SetApiKey call SetApiKey(<f-args>)

function! SetAppGW(validationId)
    let l:curlrc = expand('~/.curlrc')
    let g:netrw_http_xcmd = '-H X-Gateway-Validation-Id:' . a:validationId . ' -K' . l:curlrc . ' -o'
endfunction

command! -nargs=+ SetAppGW call SetAppGW(<f-args>)

if has('gui')
    set encoding=utf8
    if filereadable($WINDIR . '\Fonts\Hack-Regular.ttf')
        set guifont=Hack:h12:cANSI
    else
        set guifont=Consolas:h12:cANSI
    endif

    set noeb novb
endif
