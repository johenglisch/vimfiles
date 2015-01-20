" reload the vimrc and restore window view
function! s:SourceVimrc()
    let l:win = winsaveview()
    source $MYVIMRC
    call winrestview(l:win)
endfunction

command! SourceVimrc call s:SourceVimrc()
