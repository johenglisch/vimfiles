function! s:ExecuteWithSavedView(command)
    let view = winsaveview()
    exec a:command
    call winrestview(view)
endfunction

command! -nargs=1 Vexec call s:ExecuteWithSavedView(<args>)
