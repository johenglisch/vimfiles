nnoremap <buffer> <cr> :<c-u>make!<cr>

if !exists('current_compiler')
    compiler perl
endif
