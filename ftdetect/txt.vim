augroup DetectTxtFiles
    autocmd!
    autocmd BufNewFile,BufRead CMakeList.txt set filetype=cmake
    autocmd BufNewFile,BufRead *.txt,*.text,README
                \ if &filetype == "text" || empty(&filetype) |
                \   set filetype=markdown |
                \ endif
augroup END
