setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

nnoremap <buffer> <LocalLeader>2 :<C-u>!python2 %<cr>
nnoremap <buffer> <LocalLeader>3 :<C-u>!python3 %<cr>
nnoremap <buffer> <LocalLeader>d Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>
