" Function: Strip white space off the edges of a string.
function! Strip(string)
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

" Function: Return a `length' chars long string filled with `filler'.
function! FilledString(length, filler)
    if empty(a:filler)
        echoerr 'Empty fill string'
        return ''
    endif

    let l:new_string = repeat(a:filler, a:length / strlen(a:filler))
    if strlen(l:new_string) < a:length
        let l:new_string .= a:filler[:a:length - strlen(l:new_string) - 1]
    endif

    return l:new_string
endfunction
