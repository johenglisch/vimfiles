augroup TextFilesAreConsideredMarkdown
    autocmd!
    autocmd BufNewFile,BufRead *.txt,*.text,README set filetype=markdown
augroup END
