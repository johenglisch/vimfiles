compiler cargo

nnoremap <buffer> <cr> :<c-u>make! build<cr>

nnoremap ÖÖ :<c-u>!cargo run<cr>
nnoremap ÖK :<c-u>make! clean<cr>
nnoremap ÖL :<c-u>!cargo test -- --test-threads=4<cr>
