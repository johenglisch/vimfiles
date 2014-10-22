" Toggle font colours
function! g:ToggleBackground()
    if &background ==# 'dark'
        set background=light
    elseif &background ==# 'light'
        set background=
    else
        set background=dark
    endif
    echo 'set bg=' &background
endfunction
