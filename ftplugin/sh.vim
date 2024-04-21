nnoremap <backspace> :<c-u>lmake! %<cr>

if !exists('current_compiler')
    silent! compiler shellcheck
endif
