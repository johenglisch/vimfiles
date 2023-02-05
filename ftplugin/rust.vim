compiler cargo

nnoremap <buffer> <cr> :<c-u>make! build<cr>

nnoremap ÖÖ :<c-u>make! run<cr>
nnoremap ÖK :<c-u>make! clean<cr>
nnoremap ÖL :<c-u>make! test -- --test-threads=4<cr>
