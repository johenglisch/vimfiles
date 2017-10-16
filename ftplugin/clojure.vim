nnoremap <silent> <buffer> <cr> :<c-u>Require<cr>
vnoremap <silent> <buffer> <cr> :Eval<cr>

nnoremap <silent> <buffer> <localleader>K :<C-u>%Eval<cr>
vnoremap <silent> <buffer> <localleader>K :Eval<cr>

nnoremap <silent> <buffer> <localleader>L vip:Eval<cr>
