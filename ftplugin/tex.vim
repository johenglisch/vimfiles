" APPEARANCE

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal linebreak


" EDITING

set iskeyword+=:

let g:Tex_SmartKeyQuote = 0

let g:Tex_FoldedEnvironments="abstract,titlepage"
let g:Tex_FoldedMisc="preamble,<<<"

let g:Tex_IgnoreLevel = 8
let g:Tex_IgnoredWarnings =
            \'Underfull'."\n".
            \'Overfull'."\n".
            \'specifier changed to'."\n".
            \'You have requested'."\n".
            \'Missing number, treated as zero.'."\n".
            \'There were undefined references'."\n".
            \'Citation %.%# undefined'."\n".
            \'LaTeX Font Warning: %.%#'


" KEY BINDINGS

let g:Tex_Leader = "§"

nnoremap <buffer> <cr> :<c-u>call Tex_RunLaTeX()<cr>

nnoremap <buffer> <localleader>K :<c-u>TexRemoveAuxiliaryFiles<cr>
nnoremap <buffer> <localleader>L :<c-u>call Tex_RunLaTeX()<cr>
nnoremap <buffer> <localleader>M :<c-u>call Tex_ViewLaTeX()<cr>
nnoremap <buffer> <localleader>N A% TODO<space>


" COMPILATION OPTIONS

let g:Tex_MultipleCompileFormats = "dvi,ps"
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_FormatDependency_ps = "dvi,ps"
let g:Tex_FormatDependency_pdf = "dvi,ps,pdf"
let g:Tex_CompileRule_dvi = "latex --interaction=nonstopmode $*"
let g:Tex_CompileRule_ps = "dvips -Ppdf -o $*.ps $*.dvi"
let g:Tex_CompileRule_pdf = "ps2pdf $*.ps"

if has('win32')
    let g:Tex_ViewRule_dvi = "C:/Program Files/MiKTeX 2.9/miktex/bin/x64/yap.exe $*.pdf"
    let g:Tex_ViewRule_pdf = "C:/Program Files (x86)/SumatraPDF/SumatraPDF.exe $*.pdf"
else
    let g:Tex_ViewRule_dvi = $PDFVIEWER . " $*.dvi 2>/dev/null >/dev/null"
    let g:Tex_ViewRule_pdf = $PDFVIEWER . " $*.pdf 2>/dev/null >/dev/null"
endif


" HANDLING OF AUXILIARY FILES

if exists('g:Tex_AuxFileExtensions')
    let s:Tex_AuxFileExtensions = g:Tex_AuxFileExtensions
else
    let s:Tex_AuxFileExtensions = [
                \ 'aux', 'bbl', 'blg', 'dbj', 'dvi', 'log',
                \ 'nav', 'out', 'ps', 'snm', 'toc']
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
