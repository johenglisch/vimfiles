function! s:FixCommas() range abort
    if a:firstline != a:lastline
        exec a:firstline . "," . (a:lastline - 1) "s/\\v,?$/,/"
    endif
    silent! exec a:lastline "s/,$//"
endfunction

command! -buffer -range FixCommas <line1>,<line2>call s:FixCommas()

nnoremap <buffer> ÖÖ :<c-u>FixCommas<cr>
vnoremap <buffer> ÖÖ :FixCommas<cr>

nnoremap <buffer> ÖK :<c-u>%!json_pp<cr>
