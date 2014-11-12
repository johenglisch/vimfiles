" conceal '\emph' as if it were '\textit'
if !exists(g:tex_conceal) || g:tex_conceal =~ 'b'
   syn region texItalStyle matchgroup=texTypeStyle start="\\emph\s*{" end="}" concealends contains=@texItalGroup
endif

" conceal additional characters
if !exists(g:tex_conceal) || g:tex_conceal =~ 'a'
  " punctuation
  syn match texAccent '---'           conceal cchar=—
  syn match texAccent '--'            conceal cchar=–
  syn match texAccent '>>'            conceal cchar=»
  syn match texAccent '<<'            conceal cchar=«
  syn match texAccent '``'            conceal cchar=“
  syn match texAccent "''"            conceal cchar=”
  syn match texAccent '\\dots\>'      conceal cchar=…
  syn match texAccent '\\ldots\>'     conceal cchar=…

  " ipa
  syn match texAccent '\\textschwa\>' conceal cchar=ə
endif
