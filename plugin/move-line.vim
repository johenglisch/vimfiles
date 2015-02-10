" Function: Move the current line downwards by (line2-line1) lines.
function! s:MoveLineDownwards(line1, line2)
    let destination = (a:line1 < a:line2) ? a:line2 : a:line1

    let register = @@
    exec 'normal! dd' . destination . 'Gp'
    let @@ = register
endfunction

" Function: Move the current line upwards by (line2-line1) lines.
function! s:MoveLineUpwards(line1, line2)
    let offset = (a:line1 < a:line2) ? (a:line2 - a:line1) : 0
    let destination = (offset < a:line1 - 1) ? (a:line1 - 1 - offset) : 1

    let register = @@
    exec 'normal! dd' . destination . 'GP'
    let @@ = register
endfunction


command! -count=1 MoveLineUpwards call s:MoveLineUpwards(<line1>, <line2>)
command! -count=1 MoveLineDownwards call s:MoveLineDownwards(<line1>, <line2>)
