setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal noexpandtab

augroup AAAAAARRRRGGGHHHH
    autocmd!
    autocmd BufWinEnter,Colorscheme <buffer> syntax match BloodySemicolons /;$/
    autocmd BufWinEnter,Colorscheme <buffer> highlight link BloodySemicolons Error
augroup END

" nnoremap <buffer> ÖI :<c-u>GoImports<cr>
" nnoremap <buffer> <cr> :<c-u>GoBuild<cr>
nnoremap <buffer> <cr> :<c-u>make!<cr>

if !exists('current_compiler')
    compiler go
endif
