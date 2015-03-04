function! s:ToggleBackground()
    if &background ==# 'light'
        set background=dark
    else
        set background=light
    endif
    echo 'set background=' &background
endfunction

command! ToggleBackground call s:ToggleBackground()
