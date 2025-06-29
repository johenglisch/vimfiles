set linebreak
set noautoindent
set nosmartindent

function! s:AddTimeStampToPar() abort
    normal! mm{o### =strftime('%H:%M:%S')`m<cr>
endfunction

function! s:InsertDate() abort
    normal! mmO## =strftime('%a, %d %b %Y')`m
endfunction

function! s:AppendIsoDate() abort
    normal! a=strftime('%Y-%m-%d')
endfunction

function! s:InsertIsoDate() abort
    normal! i=strftime('%Y-%m-%d')
endfunction

command! -buffer TimeStampToPar call s:AddTimeStampToPar()
command! -buffer InsertDate call s:InsertDate()
command! -buffer AppendIsoDate call s:AppendIsoDate()
command! -buffer InsertDate calls s:InsertIsoDate()

nnoremap <buffer> ÖÖ :<c-u>TimeStampToPar<cr>
nnoremap <buffer> Öd :<c-u>InsertDate<cr>
nnoremap <buffer> ÖI :<c-u>InsertIsoDate<cr>
nnoremap <buffer> Öi :<c-u>AppendIsoDate<cr>
inoremap <buffer> <c-x><c-a> <c-o>:TimeStampToPar<cr>
