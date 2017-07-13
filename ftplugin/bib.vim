setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

setlocal iskeyword+=:

nnoremap <localleader><localleader> :lgrep ^@ %<cr>:lopen<cr>
