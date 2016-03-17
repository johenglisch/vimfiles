" Appearance

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal linebreak


" Editing Options

set iskeyword+=:

nnoremap <buffer> <cr> :<c-u>VimtexCompile<cr>

nnoremap <buffer> <localleader>K :<c-u>TexRemoveAuxiliaryFiles<cr>
nnoremap <buffer> <localleader>L :<c-u>VimtexCompile<cr>
nnoremap <buffer> <localleader>N A% TODO<space>


" Handling Auxiliary Files

if exists('g:Tex_AuxFileExtensions')
    let s:Tex_AuxFileExtensions = g:Tex_AuxFileExtensions
else
    let s:Tex_AuxFileExtensions = [
                \ 'aux', 'bbl', 'blg', 'dbj', 'dvi', 'log',
                \ 'nav', 'out', 'ps', 'snm', 'toc',
                \ 'fdb_latexmk', 'fls']
endif

function! s:Tex_RemoveAuxiliaryFiles()
    let file_root = expand('%:r')

    for extension in s:Tex_AuxFileExtensions
        let auxiliary_file = file_root . '.' . extension

        if filewritable(auxiliary_file)
            if delete(auxiliary_file) == 0
                echomsg "Removed '" . auxiliary_file . "'"
            else
                echoerr "Could not remove '" . auxiliary_file . "'"
            endif
        endif
    endfor
endfunction

command! -buffer TexRemoveAuxiliaryFiles call s:Tex_RemoveAuxiliaryFiles()
