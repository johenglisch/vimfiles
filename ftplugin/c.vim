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
        let fname = s:FindByExt(root, ['.h', '.hpp', '.H'])
    else
        let fname = s:FindByExt(root, ['.c', '.cpp'])
    end

    if !empty(fname)
        exec 'edit ' . fname
    else
        echo 'No header/source found.'
    endif
endfunction


command! ToggleHeader call s:ToggleHeader()


nnoremap <buffer> <cr> :<c-u>make!<cr>
nnoremap <leader><tab> :<c-u>ToggleHeader<cr>
