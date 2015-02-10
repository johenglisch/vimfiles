function! Strip(string)
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

" Function: Return a `length' chars long string filled with `filler'.
function! FilledString(length, filler)
    if empty(a:filler)
        echoerr 'Empty fill string'
        return ''
    endif

    let new_string = repeat(a:filler, a:length / strlen(a:filler))
    if strlen(new_string) < a:length
        let new_string .= a:filler[:a:length - strlen(new_string) - 1]
    endif

    return new_string
endfunction
