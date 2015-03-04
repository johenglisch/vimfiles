set linebreak
set noautoindent
set nosmartindent


function! s:ToggleCheckbox()
    let line = getline('.')
    if line =~ "\\[X\\]"
        substitute/\v\[X\]/[ ]
    else
        substitute/\v\[ \]/[X]/e
    endif
endfunction

command! -buffer MarkdownToggleCheckbox call s:ToggleCheckbox()

nnoremap <buffer> <silent> <localleader>: :MarkdownToggleCheckbox<cr>
