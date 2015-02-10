scriptencoding 'utf-8'

if !exists(g:tex_conceal) || g:tex_conceal =~ 'b'
    syn region texItalStyle matchgroup=texTypeStyle start="\\emph\s*{" end="}" concealends contains=@texItalGroup
endif

if !exists(g:tex_conceal) || g:tex_conceal =~ 'a'
    if &enc == 'utf-8'
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

        syn match texStatement '\\textschwa\>\s*' conceal cchar=ə
    endif
endif
