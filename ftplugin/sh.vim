setlocal makeprg=shellcheck\ -f\ gcc\ %

nnoremap <backspace> :<c-u>lmake!<cr>
