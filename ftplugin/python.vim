let g:pymode_options = 0
setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

let g:pymode_syntax = 0
let python_no_number_highlight = 1
let python_space_error_highlight = 1

let g:python_doc = 0
let g:pymode_rope_complete_on_dot = 0

let g:pymode_run_bind = '<cr>'
nnoremap <buffer> <LocalLeader>2 :call RunInPython(expand("%:p"), "2.7")<cr>
nnoremap <buffer> <LocalLeader>3 :call RunInPython(expand("%:p"), "3.4")<cr>
nnoremap <buffer> <LocalLeader>d Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>
