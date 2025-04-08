set lisp
setlocal lispwords=def,fn,defn
setlocal lispwords+=if,when,loop,while,for,each
setlocal lispwords+=let,if-let

if !exists('current_compiler')
    compiler janet
endif

set comments=:#
set commentstring=#%s

nnoremap <buffer> <backspace> :<c-u>make!<cr>
