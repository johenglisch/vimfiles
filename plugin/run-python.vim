" http://learnvimscriptthehardway.stevelosh.com/chapters/49.html

" run file in python 2/3
function! g:RunInPython(filename, version)
    exec "!python" . a:version . " " . a:filename
endfunction
