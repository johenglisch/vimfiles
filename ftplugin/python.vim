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


let &l:makeprg = 'python3 -m pylint -sn'


nnoremap <buffer> ÖJ Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>

nnoremap <buffer> <cr> :<c-u>call <sid>RunTests()<cr>
nnoremap <buffer> <backspace> :<c-u>lmake! %<cr>
