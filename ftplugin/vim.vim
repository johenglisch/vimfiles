" Source current vim plugin.
command! -buffer SourceThis exec "source ".bufname("%") |
            \echomsg "sourced" bufname("%")
nnoremap <buffer> <cr> :SourceThis<cr>
