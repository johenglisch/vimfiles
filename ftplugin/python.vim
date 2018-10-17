setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

function s:RunTests() abort
    !python3 -m unittest
endfunction

nnoremap <buffer> <LocalLeader>J Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>
nnoremap <buffer> <cr> :<c-u>call <sid>RunTests()<cr>
