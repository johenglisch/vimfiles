setlocal makeprg=hare

" TODO change to something more reasonable
nnoremap <buffer> <cr> :<c-u>make! run %<cr>

" nnoremap ÖÖ :<c-u>!hare run<cr>
" nnoremap ÖK :<c-u>!hare clean<cr>
" nnoremap ÖL :<c-u>!hare test<cr>
nnoremap ÖÖ :<c-u>make! run<cr>
nnoremap ÖK :<c-u>make! clean<cr>
nnoremap ÖL :<c-u>make! test<cr>
