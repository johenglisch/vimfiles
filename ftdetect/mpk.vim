" enable syntax highlighting for mamake packages
augroup MamakePackageFileDetect
    autocmd!
    autocmd BufNewFile,BufRead *.mpk set filetype=sh
augroup END
