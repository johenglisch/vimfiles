set foldmethod=syntax
set foldnestmax=1

function! s:FindByExt(root, exts)
    for e in a:exts
        let fname = findfile(a:root.e)
        if !empty(fname)
            return fname
        endif
    endfor
    return ''
endfunction

function! s:ToggleHeader()
    let root = expand("%:t:r")
    let ext = expand("%:e")

    if ext == 'c' || ext == 'cpp'
        return s:FindByExt(root, ['.h', '.hpp', '.H'])
    endif

    if ext == 'h' || ext == 'hpp' || ext == 'H'
        return s:FindByExt(root, ['.c', '.cpp'])
    end

    return ''
endfunction


nnoremap <leader><tab> :<c-u>exec 'edit ' . <sid>ToggleHeader()<cr>
