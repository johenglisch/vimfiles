setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

nnoremap <buffer> <LocalLeader>2 :call RunInPython(expand("%:p"), "2.7")<cr>
nnoremap <buffer> <LocalLeader>3 :call RunInPython(expand("%:p"), "3.4")<cr>
nnoremap <buffer> <LocalLeader>d Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>
