compiler cargo

nnoremap <buffer> <cr> :<c-u>make! build<cr>

nnoremap <localleader><localleader> :<c-u>!cargo run<cr>
nnoremap <localleader>K :<c-u>make! clean<cr>
nnoremap <localleader>L :<c-u>!cargo test -- --test-threads=4<cr>
