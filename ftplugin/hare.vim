nnoremap <buffer> <cr> :<c-u>make!<cr>

nnoremap ÖÖ :<c-u>!hare run<cr>
nnoremap ÖK :<c-u>!hare clean<cr>
nnoremap ÖL :<c-u>!hare test<cr>

if !exists('current_compiler')
    compiler hare
endif
