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

function! s:ToggleHeading()
    let line = getline('.')
    if line =~ "^###"
        substitute/\v^###\s*(.{-})(\s*###)?$/\1/
    elseif line =~ "^##"
        substitute/\v^##\s*(.{-})(\s*##)?$/### \1 ###/e
    elseif line =~ "^#"
        substitute/\v^#\s*(.{-})(\s*#)?$/## \1 ##/e
    else
        substitute/\v^(.*)$/# \1 #/
    endif
endfunction


command! -buffer MarkdownToggleCheckbox call s:ToggleCheckbox()
command! -buffer MarkdownToggleHeading  call s:ToggleHeading()


" TODO nicer keybindings?
nnoremap <buffer> <silent> <localleader>O :MarkdownToggleCheckbox<cr>
nnoremap <buffer> <silent> <localleader>H :MarkdownToggleHeading<cr>
