setlocal softtabstop=2
setlocal shiftwidth=2

setlocal makeprg=dune\ build

nnoremap <buffer> <cr> :<c-u>make!<cr>
