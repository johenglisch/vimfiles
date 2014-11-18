" Toggle font colours
function! g:ToggleBackground()
    if &background ==# 'light'
        set background=dark
    else
        set background=light
    endif
    echo 'set bg=' &background
endfunction
