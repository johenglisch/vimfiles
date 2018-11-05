" Retrieve name of the current namespace.
function! s:NameSpace() abort
    let l:view = winsaveview()

    " Starting the search on line 1 does not work if the match is exactly on
    " column 1 (which namespace declarations sometimes are), so instead let's
    " start at the last column of the last line and have the search wrap around.
    let l:search_register = @/
    exec "normal! G$/\\V(ns\\>\<cr>W"
    let @/ = l:search_register

    " This assumes that all tests for namespace "foo" are in namespace
    " "foo-test" (and that all testmodules end on -test).
    let l:ns = expand('<cWORD>')
    if l:ns !~? '\v-test$'
        let l:ns .= '-test'
    endif

    call winrestview(l:view)
    return l:ns
endfunction


nnoremap <silent> <buffer> <cr> :<c-u>Require!<cr>
vnoremap <silent> <buffer> <cr> :Eval<cr>

nnoremap <silent> <buffer> ÖK :<C-u>%Eval<cr>
vnoremap <silent> <buffer> ÖK :Eval<cr>

nnoremap <silent> <buffer> ÖL :exec "RunTests " . <sid>NameSpace()<cr>
