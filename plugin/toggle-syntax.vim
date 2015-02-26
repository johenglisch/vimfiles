function! s:ToggleHighlighting()
    if empty(&syntax) || &syntax == 'OFF'
        setlocal syntax=ON
    else
        setlocal syntax=OFF
    endif
endfunction

command! ToggleHighlighting call s:ToggleHighlighting()
