nnoremap <backspace> :<c-u>lmake! %<cr>

if !exists('current_compiler')
    compiler shellcheck
endif
