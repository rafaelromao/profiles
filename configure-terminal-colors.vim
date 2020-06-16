if !has('gui') && has('win32')
    if !empty($CONEMUBUILD)
        set term=xterm
        set termencoding=utf8
        let &t_AB="\e[48;5;%dm"
        let &t_AF="\e[38;5;%dm"
        normal! a
    endif
    if v:version >= 800
        set termguicolors
    endif
    set t_Co=256
else
    if v:version >= 800
        set termguicolors
    endif
endif

if &term == 'screen-256color'
    set term=xterm-256color
endif

if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

