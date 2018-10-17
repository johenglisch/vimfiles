setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

function! s:RunTests() abort
    if exists('b:git_dir')
        exec 'silent lchdir ' . fnamemodify(b:git_dir, ':h')
        !python3 -m unittest
        silent lchdir -
    else
        !python3 -m unittest
    endif
endfunction

nnoremap <buffer> <LocalLeader>J Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>
nnoremap <buffer> <cr> :<c-u>call <sid>RunTests()<cr>
