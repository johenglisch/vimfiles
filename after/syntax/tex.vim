scriptencoding 'utf-8'

" conceal '\emph' as if it were '\textit'
if !exists(g:tex_conceal) || g:tex_conceal =~ 'b'
    syn region texItalStyle matchgroup=texTypeStyle start="\\emph\s*{" end="}" concealends contains=@texItalGroup
endif

" conceal additional characters
if !exists(g:tex_conceal) || g:tex_conceal =~ 'a'
    if &enc == 'utf-8'
        " punctuation
        syn match texAccent    '---'           conceal cchar=—
        syn match texAccent    '--'            conceal cchar=–
        syn match texAccent    '>>'            conceal cchar=»
        syn match texAccent    '<<'            conceal cchar=«
        syn match texAccent    '``'            conceal cchar=“
        syn match texAccent    "''"            conceal cchar=”
        syn match texStatement '\\dots\>\s*'   conceal cchar=…
        syn match texStatement '\\ldots\>\s*'  conceal cchar=…
        syn match texStatement '\\lbrack\>\s*' conceal cchar=[
        syn match texStatement '\\rbrack\>\s*' conceal cchar=]

        " ipa
        syn match texStatement '\\textschwa\>\s*' conceal cchar=ə
    endif
endif
