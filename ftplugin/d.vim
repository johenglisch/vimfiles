" TODO: proper compiler plugins
if exists('g:dlang_compiler')
    let s:dlang_compiler = g:dlang_compiler
else
    let s:dlang_compiler = 'dmd'
endif


function! s:DlangCompile() abort
    if filereadable('./dub.json')
        echo 'Running dub'
        !dub build
    elseif filereadable('./Makefile')
        echo 'Running make'
        make!
    else
        echo 'Running' s:dlang_compiler
        echo system(s:dlang_compiler.' '.shellescape(expand('%')))
    endif
endfunction

setlocal noexpandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4


command! -buffer DlangCompile call s:DlangCompile()


nnoremap <silent> <buffer> <cr> :DlangCompile<cr>
nnoremap <silent> <buffer> ÖM :exec "!rdmd -main -unittest " . expand("%")<cr>
