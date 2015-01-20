" APPEARANCE {{{

" indentation and tabs
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal linebreak

" " make vim slightly more wysiwyg
" if has("gui_running") && has("conceal")
"   setlocal conceallevel=2
" endif

" disable auto completion of quotation marks
let g:Tex_SmartKeyQuote = 0


" }}}

" EDITING {{{

" use C-n for cycling through label keywords
set iskeyword+=:

" folding
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


" }}}

" KEY BINDINGS {{{

" set tex leader to the most useless character on the keyboard...
let g:Tex_Leader = "§"

" compile on return
nnoremap <buffer> <cr> :call Tex_RunLaTeX()<cr>

" local leader mappings
nnoremap <buffer> <localleader>K :TexCleanDir<cr>
nnoremap <buffer> <localleader>L :call Tex_RunLaTeX()<cr>
nnoremap <buffer> <localleader>M :call Tex_ViewLaTeX()<cr>


"}}}

" COMPILE/VIEW OPTIONS {{{

let g:Tex_AuxFileExtensions = ['aux', 'bbl', 'blg', 'dbj', 'dvi', 'log',
                              \'nav', 'out', 'ps', 'snm', 'toc']

" Function: Clean auxiliary files latex leaves behind.
function! s:Tex_CleanLaTeX()

  " expand file name and strip extension
  let l:filebase = expand('%:r')

  for l:ext in g:Tex_AuxFileExtensions
    " compose file name
    let l:auxfile = l:filebase.'.'.l:ext

    if filewritable(l:auxfile)
      if delete(l:auxfile) == 0
        echomsg "Removed '".l:auxfile."'"
      else
        echoerr "Could not remove '".l:auxfile."'"
      endif
    endif

  endfor
endfunction

command! TexCleanDir call s:Tex_CleanLaTeX()

" latex quick build (dvi->ps->pdf)
let g:Tex_MultipleCompileFormats = "dvi,ps"
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_FormatDependency_ps = "dvi,ps"
let g:Tex_FormatDependency_pdf = "dvi,ps,pdf"
let g:Tex_CompileRule_dvi = "latex --interaction=nonstopmode $*"
let g:Tex_CompileRule_ps = "dvips -Ppdf -o $*.ps $*.dvi"
let g:Tex_CompileRule_pdf = "ps2pdf $*.ps"

" set dvi and pdf viewer depending on os
if has('win32')
    let g:Tex_ViewRule_dvi = "C:/Program Files/MiKTeX 2.9/miktex/bin/x64/yap.exe $*.pdf"
    let g:Tex_ViewRule_pdf = "C:/Program Files (x86)/SumatraPDF/SumatraPDF.exe $*.pdf"
else
    let g:Tex_ViewRule_dvi = "okular $*.dvi 2>/dev/null >/dev/null"
    let g:Tex_ViewRule_pdf = "okular $*.pdf 2>/dev/null >/dev/null"
endif

" }}}

" vim:foldmethod=marker:nofoldenable
