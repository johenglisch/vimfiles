" Clamp a `value` between `min` and `max`.
function! Clamp(value, min, max) abort
    return min([a:max, max([a:min, a:value])])
endfunction

" Create a string of a given `length` filled with the string `filler`.
function! FilledString(length, filler) abort
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

" Remove whitespace at the beginning and end of a `string`.
function! Strip(string) abort
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction
