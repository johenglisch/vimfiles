setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal expandtab

setlocal iskeyword+=:

nnoremap ÖÖ :lvimgrep /^@/ %<cr>:lopen<cr>
