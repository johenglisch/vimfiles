setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

setlocal iskeyword+=:

nnoremap <localleader><localleader> :lvimgrep /^@/ %<cr>:lopen<cr>
