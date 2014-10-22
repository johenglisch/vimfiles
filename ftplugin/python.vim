" disable little documentation window
let g:python_doc = 0

" highlighting
let g:pymode_syntax = 0
let python_no_number_highlight = 1
let python_space_error_highlight = 1

" plugin shortcuts
nnoremap <buffer> <LocalLeader>2 :call RunInPython(expand("%:p"), "2.7")<cr>
nnoremap <buffer> <LocalLeader>3 :call RunInPython(expand("%:p"), "3.3")<cr>
nnoremap <buffer> <LocalLeader>d Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>
