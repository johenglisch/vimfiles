function! s:SourceCurrentLine()
    let l:line = Strip(getline('.'))
    echo ':' . l:line
    exec l:line
endfunction

function! s:SourceCurrentFile()
    let l:filename = bufname('%')
    exec 'source ' . l:filename
    echo 'Sourced' l:filename
endfunction


command! -buffer SourceCurrentFile call s:SourceCurrentFile()
command! -buffer SourceCurrentLine call s:SourceCurrentLine()


nnoremap <silent> <buffer> <cr>   :SourceCurrentFile<cr>
nnoremap <silent> <buffer> <S-cr> :SourceCurrentLine<cr>

" TODO check for set or (
nnoremap <silent> <buffer> K      :exec 'help ' . expand('<cword>')<cr>
