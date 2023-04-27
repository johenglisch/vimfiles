let &l:makeprg =
            \ 'perl -Mstrict -cw % 2>&1'
            \ . " \\| perl -pne 's/^(.*?) at (.*?) line (\\d+)(.*)$/$2:$3: $1$4/'"

nnoremap <buffer> <cr> :<c-u>make!<cr>
