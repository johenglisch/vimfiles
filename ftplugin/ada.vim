setlocal softtabstop=3
setlocal shiftwidth=3
setlocal expandtab

nnoremap <buffer> <cr> :<c-u>make!<cr>

if !exists('current_compiler')
    compiler alire
endif
