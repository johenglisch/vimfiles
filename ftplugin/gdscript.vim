setlocal tabstop=4
setlocal softtabstop=4
setlocal noexpandtab
setlocal shiftwidth=4

augroup AAAAAAAAARRRRGGGHHHH
    autocmd!
    autocmd BufWinEnter,Colorscheme <buffer> syntax keyword BloodyDefs def
    autocmd BufWinEnter,Colorscheme <buffer> highlight link BloodyDefs Error
augroup END
