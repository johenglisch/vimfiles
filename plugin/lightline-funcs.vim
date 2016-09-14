function! LightLineMode()
    let mode = lightline#mode()
    return winwidth(0) > 70 ? mode : mode[0]
endfunction

function! LightLineFugitive()
    if winwidth(0) <= 70 || !exists("*fugitive#head")
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

function! LightLineNeomake()
    if winwidth(0) <= 70 || !exists("*neomake#statusline#LoclistStatus")
        return ''
    endif
    return neomake#statusline#LoclistStatus()
endfunction
