function! s:Underline(filler_string)
    " abort on <esc>
    if char2nr(a:filler_string) == 27
        return
    endif

    let underlining = FilledString(strlen(getline('.')), a:filler_string)
    if !empty(underlining)
        call append('.', underlining)
    endif
endfunction

function! s:Overline(filler_string)
    " abort on <esc>
    if char2nr(a:filler_string) == 27
        return
    endif

    let underlining = FilledString(strlen(getline('.')), a:filler_string)
    if !empty(underlining)
        call append(line('.') - 1, underlining)
    endif
endfunction


command! -nargs=1 Underline call s:Underline(<args>)
command! -nargs=1 Overline  call s:Overline(<args>)
