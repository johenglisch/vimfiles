" stop pymode from screwing with my options (-_-)"
let g:pymode_options = 0
setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

" make syntax highlighting less excessive
let g:pymode_syntax = 0
let python_no_number_highlight = 1
let python_space_error_highlight = 1

" disable documentation window
let g:python_doc = 0

" completion only on my command (because of lag in big modules like wx)
let g:pymode_rope_complete_on_dot = 0

" run buffer on <cr>
let g:pymode_run_bind = '<cr>'

" plugin shortcuts
nnoremap <buffer> <LocalLeader>2 :call RunInPython(expand("%:p"), "2.7")<cr>
nnoremap <buffer> <LocalLeader>3 :call RunInPython(expand("%:p"), "3.3")<cr>
nnoremap <buffer> <LocalLeader>d Oimport pdb; pdb.set_trace()  # TODO REMOVE<esc>
