" Appearance

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal linebreak


" Editing Options

set iskeyword+=:

nnoremap <buffer> <cr> :<c-u>VimtexCompileSS<cr>

nnoremap <buffer> <localleader>K :<c-u>TexRemoveAuxiliaryFiles<cr>
nnoremap <buffer> <localleader>L :<c-u>VimtexCompileSS<cr>
nnoremap <buffer> <localleader>N A% TODO<space>


" Text-to-Speech

function! s:ReadSelection() range abort
    let lines = map(
                \ getline(a:firstline, a:lastline),
                \ 'substitute(v:val, ''%.*$'', "", "")')

    let tex_code = join(lines, "\n")
    let tex_code = substitute(tex_code, '\\citep{.\{-\}}', '', 'g')
    let tex_code = substitute(tex_code, '\\\%(Next\|Last\|NNext\|LLast\)\>', 'The Example', 'g')
    let tex_code = substitute(tex_code, '\(\\\%(sub\)*section{.\{-\}\)\(}\)', '\1.\2', 'g')

    let plaintext = system("detex -cl -e array,figure,table,tikzpicture", tex_code)
    let plaintext = join(split(plaintext), " ")

    echo "Reading..."
    call system("espeak -p30 -s130 -ven-uk-north", plaintext)
    echo "Done."
endfunction

command! -buffer -range=% ReadOut <line1>,<line2>call s:ReadSelection()


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
