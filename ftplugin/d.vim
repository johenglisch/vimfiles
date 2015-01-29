if exists('g:dlang_compiler')
    let s:dlang_compiler = g:dlang_compiler
else
    let s:dlang_compiler = 'dmd'
endif


function! s:DlangCompile()
    if filereadable('./dub.json')
        echo 'Running dub'
        !dub build
    elseif filereadable('./Makefile')
        echo 'Running make'
        make!
    else
        let l:command = s:dlang_compiler . ' ' . shellescape(expand('%'))
        echo 'Running' l:command

        let l:output = system(l:command)
        echo substitute(l:output, '\n\r?', '\r', 'g')
    endif
endfunction


command! -buffer DlangCompile call s:DlangCompile()

nnoremap <silent> <buffer> <cr> :DlangCompile<cr>
