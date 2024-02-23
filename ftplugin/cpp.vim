" TODO: make compiler plugin
function s:HandmadeLikeProject() abort
    setlocal makeprg=sh\ ./Build.sh
endfunction

command! -buffer HandmadeLike call s:HandmadeLikeProject()
