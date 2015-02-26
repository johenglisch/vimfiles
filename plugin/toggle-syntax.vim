function! s:ToggleHighlighting()
    if empty(&syntax) || &syntax ==# 'OFF'
        exec 'setlocal syntax=' . &filetype
    else
        setlocal syntax=OFF
    endif
endfunction

command! ToggleHighlighting call s:ToggleHighlighting()
