function! s:CleanWhiteSpace() range
    let search_register = @/
    exec a:firstline . ',' . a:lastline . 'substitute/\s\+$//e'
    let @/ = search_register
endfunction


command! -range=% CleanWhiteSpace <line1>,<line2>call s:CleanWhiteSpace()
