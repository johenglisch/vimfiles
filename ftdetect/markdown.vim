augroup UseMarkdownForTxt
    autocmd!
    autocmd BufNewFile,BufRead *.txt,*.text,README
                \ if &filetype == "text" || empty(&filetype) |
                \   set filetype=markdown |
                \ endif
augroup END
