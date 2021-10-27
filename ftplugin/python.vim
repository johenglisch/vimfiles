setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)


function! s:ListDefinitions() abort
    lvimgrep /^\s*\(def\|class\)/j %
    lopen
endfunction

function! s:RunTests() abort
    if exists('b:git_dir')
        exec 'silent lchdir ' . fnamemodify(b:git_dir, ':h')
    endif

    !python3 -m unittest

    if exists('b:git_dir')
        silent lchdir -
    endif
endfunction


let &l:makeprg = 'python3 -m flake8'


nnoremap <buffer> ÖJ Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>
nnoremap <buffer> ÖL :<c-u>call <sid>ListDefinitions()<cr>

nnoremap <buffer> <cr> :<c-u>call <sid>RunTests()<cr>
nnoremap <buffer> <backspace> :<c-u>make!<cr>
