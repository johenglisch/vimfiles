setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

nnoremap <buffer> <LocalLeader>d Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>
