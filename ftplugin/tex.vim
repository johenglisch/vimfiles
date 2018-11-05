" Appearance

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal linebreak


" Editing Options

set iskeyword+=:

nnoremap <buffer> <cr> :<c-u>VimtexCompileSS<cr>

nnoremap <buffer> ÖK :<c-u>TexRemoveAuxiliaryFiles<cr>
nnoremap <buffer> ÖL :<c-u>VimtexCompileSS<cr>
nnoremap <buffer> ÖN A% TODO<space>

nnoremap <buffer> ÖÖ :<c-u>ReadOut<cr>
vnoremap <buffer> ÖÖ :ReadOut<cr>


" Text-to-Speech

function! s:PrepareTexCode(lines) abort
    " Strip comments
    "
    " Checking for escaped %-signs leads to overlapping regex matches, if there
    " are two comments *right* after one another.  This can be avoided by
    " removing all lines starting with a comment beforehand.
    call filter(a:lines, "v:val !~# '^%'")
    let l:tex_code = join(a:lines, "\n")
    let l:tex_code = substitute(l:tex_code, '\v[^\\]%(\\\\)*\zs\%.{-}\n', '', 'g')

    " Make some commands more readable for espeak
    " FIXME The backslashes could be escaped too, why not...
    let l:tex_code = substitute(l:tex_code, '\v\\citep\{.{-}\}', '', 'g')
    let l:tex_code = substitute(l:tex_code, '\v\\%(NN?ext|LL?ast)>', 'The Example', 'g')
    let l:tex_code = substitute(l:tex_code, '\v\\%(sub)*section\*?\{\zs.{-}\ze\}', '&.', 'g')

    " Collapse paragraphs into single lines
    let l:tex_code = substitute(l:tex_code, '\s\+\n\s\+', '\n', 'g')
    let l:tex_code = substitute(l:tex_code, '\n\n\+\n', '\n\n', 'g')
    let l:tex_code = substitute(l:tex_code, '[^\n]\zs\n\ze[^\n]', ' ', 'g')

    return l:tex_code
endfunction

function! s:ReadRange() range abort
    let l:tex_code = s:PrepareTexCode(getline(a:firstline, a:lastline))
    let l:plaintext = system('detex -cl -e array,figure,table,tikzpicture', l:tex_code)

    let l:voice = get(b:, 'voice', 'en-uk-north')

    echo 'Reading...'
    call system('espeak -p30 -s140 -v'.l:voice, l:plaintext)
    echo 'Done.'
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

function! s:Tex_RemoveAuxiliaryFiles() abort
    let l:file_root = expand('%:r')

    for l:extension in s:Tex_AuxFileExtensions
        let l:auxiliary_file = l:file_root . '.' . l:extension

        if filewritable(l:auxiliary_file)
            if delete(l:auxiliary_file) == 0
                echomsg "Removed '" . l:auxiliary_file . "'"
            else
                echoerr "Could not remove '" . l:auxiliary_file . "'"
            endif
        endif
    endfor
endfunction

command! -buffer TexRemoveAuxiliaryFiles call s:Tex_RemoveAuxiliaryFiles()
