" Function:  Underline the current line by repeating the `filler_string'.
function! s:Underline(filler_string)
    " abort on <esc>
    if char2nr(a:filler_string) == 27
        return
    endif

    let l:underlining = FilledString(strlen(getline('.')), a:filler_string)
    if !empty(l:underlining)
        call append('.', l:underlining)
    endif
endfunction

" Function:  Overline the current line by repeating the `filler_string'.
function! s:Overline(filler_string)
    " abort on <esc>
    if char2nr(a:filler_string) == 27
        return
    endif

    let l:underlining = FilledString(strlen(getline('.')), a:filler_string)
    if !empty(l:underlining)
        call append(line('.') - 1, l:underlining)
    endif
endfunction


command! -nargs=1 Underline call s:Underline(<args>)
command! -nargs=1 Overline call s:Overline(<args>)
