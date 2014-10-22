" Function: Remove trailing white space within the range.
function! s:RmTrailingWS() range
    let l:save_cursor = getcurpos()
    exec a:firstline . ',' .  a:lastline . 'substitute/\v\s+$//e'
    call setpos('.', l:save_cursor)
endfunction

command! -range=% RmTrailingWS <line1>,<line2>call s:RmTrailingWS()
