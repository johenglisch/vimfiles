" Function: Change working directory to the location of the current file.
function! <SID>CdToBuffer()
    let l:dirname = expand('%:p:h')
    exec 'cd ' . l:dirname
    echo l:dirname
endfunction

command! CdToBuffer call <SID>CdToBuffer()
