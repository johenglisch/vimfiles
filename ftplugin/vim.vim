function! s:VimLExecuteLine()
    let line = Strip(getline('.'))
    if !empty(line)
        echo ':' . line
        exec line
    endif
endfunction

function! s:VimLSourceFile()
    let filename = bufname('%')
    exec 'source ' . filename
    echo 'Sourced' filename
endfunction

function! s:VimLContextHelp()
    for syntax_id in synstack(line('.'), col('.'))
        let syntax_item = synIDattr(syntax_id, 'name')

        " TODO: Detect variables or commands
        if syntax_item ==# 'vimFunc'
            exec 'help ' . expand('<cword>') . '()'
            return
        endif

        if syntax_item ==# 'vimOption'
            exec "help '" . expand('<cword>') . "'"
            return
        endif
    endfor

    exec 'help ' . expand('<cword>')
endfunction


command! -buffer VimLSourceFile  call s:VimLSourceFile()
command! -buffer VimLExecuteLine call s:VimLExecuteLine()
command! -buffer VimLContextHelp call s:VimLContextHelp()


nnoremap <silent> <buffer> K      :VimLContextHelp<cr>
nnoremap <silent> <buffer> <cr>   :VimLSourceFile<cr>
nnoremap <silent> <buffer> <S-cr> :VimLExecuteLine<cr>
" TODO: execute visual selection
