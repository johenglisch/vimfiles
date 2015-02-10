" http://learnvimscriptthehardway.stevelosh.com/chapters/49.html

function! g:RunInPython(filename, version)
    exec "!python" . a:version . " " . a:filename
endfunction
