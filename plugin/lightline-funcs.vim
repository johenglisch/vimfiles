function! LightLineMode()
    let mode = lightline#mode()
    return winwidth(0) > 70 ? mode : mode[0]
endfunction

function! LightLineFugitive()
    if !exists("*fugitive#head")
        return ''
    endif
    let branch = fugitive#head()
    return branch !=# '' ? '{'.branch.'}' : ''
endfunction

function! LightLineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFileencoding()
    return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightLineFiletype()
    return winwidth(0) > 70 ? &filetype : ''
endfunction
