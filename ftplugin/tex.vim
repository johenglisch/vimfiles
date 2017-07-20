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

nnoremap <buffer> <localleader>Ö :<c-u>ReadOut<cr>
vnoremap <buffer> <localleader>Ö :ReadOut<cr>


" Text-to-Speech

function! s:PrepareTexCode(lines)
    " Strip comments
    "
    " Checking for escaped %-signs leads to overlapping regex matches, if there
    " are two comments *right* after one another.  This can be avoided by
    " removing all lines starting with a comment beforehand.
    call filter(a:lines, 'v:val !~ ''^%''')
    let tex_code = join(a:lines, "\n")
    let tex_code = substitute(tex_code, '\v[^\\]%(\\\\)*\zs\%.{-}\n', '', 'g')

    " Make some commands more readable for espeak
    let tex_code = substitute(tex_code, '\v\\citep\{.{-}\}', '', 'g')
    let tex_code = substitute(tex_code, '\v\\%(NN?ext|LL?ast)>', 'The Example', 'g')
    let tex_code = substitute(tex_code, '\v\\%(sub)*section\*?\{\zs.{-}\ze\}', '&.', 'g')

    " Collapse paragraphs into single lines
    let tex_code = substitute(tex_code, '\s\+\n\s\+', '\n', 'g')
    let tex_code = substitute(tex_code, '\n\n\+\n', '\n\n', 'g')
    let tex_code = substitute(tex_code, '[^\n]\zs\n\ze[^\n]', ' ', 'g')

    return tex_code
endfunction

function! s:ReadRange() range abort
    let tex_code = s:PrepareTexCode(getline(a:firstline, a:lastline))
    let plaintext = system("detex -cl -e array,figure,table,tikzpicture", tex_code)

    let voice = get(b:, 'voice', 'en-uk-north')

    echo "Reading..."
    call system("espeak -p30 -s140 -v".voice, plaintext)
    echo "Done."
endfunction

command! -buffer -range=% ReadOut <line1>,<line2>call s:ReadRange()


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
