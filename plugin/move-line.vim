" Function: Move the current line downwards by (line2-line1) lines.
function! s:MoveLineDownwards(line1, line2)
    let l:dest = (a:line1 < a:line2) ? a:line2 : a:line1

    let l:register = @@
    exec 'normal! dd' . l:dest . 'Gp'
    let @@ = l:register
endfunction

" Function: Move the current line upwards by (line2-line1) lines.
function! s:MoveLineUpwards(line1, line2)
    let l:offset = (a:line1 < a:line2) ? (a:line2 - a:line1) : 0
    let l:dest = (l:offset < a:line1 - 1) ? (a:line1 - 1 - l:offset) : 1

    let l:register = @@
    exec 'normal! dd' . l:dest . 'GP'
    let @@ = l:register
endfunction


command! -count=1 MoveLineUpwards call s:MoveLineUpwards(<line1>, <line2>)
command! -count=1 MoveLineDownwards call s:MoveLineDownwards(<line1>, <line2>)
