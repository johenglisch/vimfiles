nnoremap <buffer> <cr> :<c-u>make!<cr>

augroup AAAAAAAARRRRGGGHHHH
    autocmd!
    autocmd BufWinEnter,Colorscheme <buffer> syntax match BloodySemicolons /;$/
    autocmd BufWinEnter,Colorscheme <buffer> highlight link BloodySemicolons Error
augroup END

if !exists('current_compiler')
    compiler odin
endif
