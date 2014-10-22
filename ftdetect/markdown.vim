augroup UseMarkdownByDefault
    autocmd!

    " Override 'text' filetype
    autocmd BufNewFile,BufRead *.txt,*.text,README set filetype=markdown

    " FIXME: sets texfiles to markdown
    " " Use markdown as a default without overriding anything
    " autocmd BufNewFile,BufRead * setf markdown

augroup END
