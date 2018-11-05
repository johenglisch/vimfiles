set foldmethod=syntax
set foldnestmax=1

function! s:FindByExt(root, exts) abort
    for l:e in a:exts
        let l:fname = findfile(a:root.l:e)
        if !empty(l:fname)
            return l:fname
        endif
    endfor
    return ''
endfunction

function! s:ToggleHeader() abort
    let l:root = expand('%:t:r')
    let l:ext = expand('%:e')

    if l:ext ==? 'c' || l:ext ==? 'cpp'
        return s:FindByExt(l:root, ['.h', '.hpp', '.H'])
    endif

    if l:ext ==? 'h' || l:ext ==? 'hpp'
        return s:FindByExt(l:root, ['.c', '.cpp'])
    end

    return ''
endfunction


nnoremap <buffer> <space><tab> :<c-u>exec 'edit ' . <sid>ToggleHeader()<cr>
nnoremap <buffer> <cr> :<c-u>make!<cr>
