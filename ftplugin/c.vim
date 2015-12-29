set foldmethod=syntax
set foldnestmax=1

let b:syntastic_checkers = ["clang_check"]

nnoremap <buffer> <cr> :<c-u>make!<cr>
