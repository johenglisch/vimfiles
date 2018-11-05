set linebreak
set noautoindent
set nosmartindent

function! s:AddTimeStampToPar()
    normal! mm{o### =strftime("%H:%M:%S")`m<cr>
endfunction

function! s:InsertDate()
    normal! mmO## =strftime('%a, %d %b %Y')`m
endfunction

command! TimeStampToPar call s:AddTimeStampToPar()
command! InsertDate call s:InsertDate()

nnoremap <buffer> ÖÖ :<c-u>TimeStampToPar<cr>
nnoremap <buffer> Öd :<c-u>InsertDate<cr>
inoremap <buffer> <c-x><c-a> <c-o>:TimeStampToPar<cr>
