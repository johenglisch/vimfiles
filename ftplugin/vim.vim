function! s:VimLExecuteLine()
    let l:line = Strip(getline('.'))
    if !empty(l:line)
        echo ':' . l:line
        exec l:line
    endif
endfunction

function! s:VimLSourceFile()
    let l:filename = bufname('%')
    exec 'source ' . l:filename
    echo 'Sourced' l:filename
endfunction

function! s:VimLContextHelp()
    for l:syntax_id in synstack(line('.'), col('.'))
        let l:syntax_item = synIDattr(l:syntax_id, 'name')

        " TODO: Detect variables or commands
        if l:syntax_item ==# 'vimFunc'
            exec 'help ' . expand('<cword>') . '()'
            return
        endif

        if l:syntax_item ==# 'vimOption'
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
