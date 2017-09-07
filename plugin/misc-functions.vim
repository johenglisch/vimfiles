function! s:Clamp(value, min, max)
    return min([a:max, max([a:min, a:value])])
endfunction


function! g:MoveLine(distance)
    exec 'move ' . s:Clamp(line('.') + a:distance, 0, line('$'))
endfunction


function! g:ToggleBackground()
    if &background ==# 'light'
        set background=dark
    else
        set background=light
    endif
    echo 'set background=' &background
endfunction

function! g:ToggleHighlighting()
    if empty(&syntax) || &syntax ==# 'OFF'
        exec 'setlocal syntax=' . &filetype
    else
        setlocal syntax=OFF
    endif
endfunction
