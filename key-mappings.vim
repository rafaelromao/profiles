"Map C-\ to C-], to fix issue with pt-br keyboard layout
silent! nnoremap <C-\> <C-]>

" Delete mappings
function! ForceUnmap(map, mode)
    if mapcheck(a:map, a:mode) != ""
        execute (a:mode . 'unmap ' . a:map)
    endif
endfunction

call ForceUnmap("<C-F>", "n")
call ForceUnmap("<C-F>", "i")
call ForceUnmap("<C-F>", "c")
call ForceUnmap("<C-H>", "n")
call ForceUnmap("<C-H>", "i")
call ForceUnmap("<C-H>", "c")
call ForceUnmap("<C-A>", "n")
call ForceUnmap("<C-Y>", "n")
call ForceUnmap("<C-X>", "n")

"My mappings
vnoremap G G$
nnoremap <silent> <SPACE> <SPACE>:noh<CR>

nnoremap <leader>a ggVG
vnoremap > >gv
vnoremap < <gv


nnoremap <C-J> <C-E>
nnoremap <C-K> <C-Y>
inoremap <C-J> <C-O><C-E>
inoremap <C-K> <C-O><C-Y>

nnoremap <TAB>t :tabnew<CR>
nnoremap <TAB>n :tabn<CR>
nnoremap <TAB>p :tabp<CR>
nnoremap <TAB>f :tabfirst<CR>
nnoremap <TAB>l :tablast<CR>
nnoremap <TAB>x :tabclose<CR>


" Unite
let g:unite_source_history_yank_enable = 1
if exists("*unite#filters#matcher_default#use")
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
endif
nnoremap <leader>u :<C-u>Unite -no-split<cr>
nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline outline<cr>
nnoremap <leader>b :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>

" Git Conflict merging
nnoremap <leader>c :let @/='^\(<<<<<<< \\|=======\\|>>>>>>> \)'<CR>

" Fugitive
nnoremap <leader>gs :Gstatus<CR>
noremap <silent><leader>gb :let b:hlsearch=&hlsearch<CR>:let &hlsearch=0<CR>gg/^# On branch<CR>3wy$ggO<C-R>0: <ESC>:s/\(.*\/\)\?\([^_]*\)\(_[^:]*\)\?/\2<CR>:let @/=''<CR>:let &hlsearch=b:hlsearch<CR>y$ddI<C-R>0

nnoremap <TAB><TAB> :NERDTreeFind<CR>
nnoremap <TAB><SPACE> :NERDTreeClose<CR>
nnoremap <TAB><CR> :NERDTreeFocus<CR>

" Use C-O for opening help, and C-] does not work with pt-br keyboard
nnoremap <C-]> <C-]>

" Tip from VimCasts.org -- http://vimcasts.org/episodes/soft-wrapping-text/
vnoremap <A-j> gj
vnoremap <A-k> gk
vnoremap <A-4> g$
vnoremap <A-6> g^
vnoremap <A-0> g^
nnoremap <A-j> gj
nnoremap <A-k> gk
nnoremap <A-4> g$
nnoremap <A-6> g^
nnoremap <A-0> g^

if has('nvim') && exists('g:GuiLoaded')
  for char in ['~', '^', '`', '´']
    for type in ['i', 'c', 'n', 'v']
      execute type . 'noremap ' . char . char . ' ' . char
    endfor
  endfor
endif

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
    " Play nice with supertab
    let b:SuperTabDisabled=1
    " Enable navigation with control-j and control-k in insert mode
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction

let s:cmd = 'nnoremap <leader>el :e ' . expand('<sfile>') . '<cr>'
execute s:cmd

augroup MyLocalMappings
    autocmd!

    let s:cmd = 'autocmd BufWritePost ' . expand('<sfile>:t') . ' :source ' . expand('<sfile>') 
    execute s:cmd
augroup END

