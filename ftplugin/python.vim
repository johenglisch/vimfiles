setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

nnoremap <buffer> <LocalLeader>J Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>
nnoremap <buffer> <cr> :<c-u>!python3 -m unittest<cr>
