" reload the vimrc and restore window view
function! g:ReloadVimrc()
    let l:win = winsaveview()
    source $MYVIMRC
    call winrestview(l:win)
endfunction
