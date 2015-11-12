" Filter the quickfix list and the location list based on a regex.
"
" Adapted from http://snippetrepo.com/snippets/filter-quickfix-list-in-vim


function! s:FilterQuickfixList(bang, pattern)
    let cmp = a:bang ? '!~?' : '=~?'
    call setqflist(filter(
        \ getqflist(),
        \ "v:val['text']" . cmp . " a:pattern"))
endfunction

function! s:FilterLocationList(bang, pattern)
    let cmp = a:bang ? '!~?' : '=~?'
    call setloclist(0, filter(
        \ getloclist(0),
        \ "v:val['text']" . cmp . " a:pattern"))
endfunction


command! -bang -nargs=1 Cfilter call s:FilterQuickfixList(<bang>0, <q-args>)
command! -bang -nargs=1 Lfilter call s:FilterLocationList(<bang>0, <q-args>)
